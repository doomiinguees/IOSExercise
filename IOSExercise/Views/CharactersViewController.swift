import UIKit

class CharactersViewController: PreViewController, UITableViewDelegate, UITableViewDataSource, FilterViewControllerDelegate {

    private let tableView = UITableView()
    
    private var characters: [Character] = []
    private var filteredCharacters: [Character] = []
    private var isSearching: Bool = false
    var speciesNames: [String] = []

    // selectedSpecies: Set<String>
    // Este Set precisa de guardar os NOMES das espécies (ex: "Human", "Droid")
    // e não as URLs (ex: "https://swapi.info/api/species/1/").
    // A sua declaração está correta, é a forma como o preenche e usa que precisa de ser ajustada.
    private var selectedSpecies: Set<String> = [] // Já está bom assim.
    private var selectedGender: String?
    private var sortBy: String = "name"
    private var sortAscending: Bool = true

    // UI Elements
    private let nameSortButton = UIButton(type: .system)
    private let yearSortButton = UIButton(type: .system)
    private let ascendingButton = UIButton(type: .system)
    private let descendingButton = UIButton(type: .system)
    private let filterButton = UIButton(type: .system)
    private let filterGearButton = UIButton(type: .system)

    override func viewDidLoad() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        titleLabel.text = "Characters"
        configureSearchBar(placeholder: "Search characters")

        super.setupBackground()
        super.setupLogo()
        super.addCustomBackButton()
        super.setupTitle()
        super.setupSearchBar()

        setupTableView()
        setupFilterControls()
        setupConstraints()
        
        APIService.fetchCharacters { [weak self] result in
            switch result {
                case .success(let characters):
                    self?.loadSpeciesNames(for: characters) { charactersWithSpecies in
                        self?.characters = charactersWithSpecies
                        self?.filteredCharacters = charactersWithSpecies
                        DispatchQueue.main.async {
                            self?.applyFilters()
                        }
                    }
                case .failure(let error):
                    print("Erro: \(error)")
                }
            }
        
        styleFilterButton(nameSortButton, isSelected: true)
        styleFilterButton(yearSortButton, isSelected: false)
        styleFilterButton(ascendingButton, isSelected: true)
        styleFilterButton(descendingButton, isSelected: false)

    }
    
    func loadSpeciesNames(for characters: [Character], completion: @escaping ([Character]) -> Void) {
        var updatedCharacters = characters
        let group = DispatchGroup()

        for (index, character) in updatedCharacters.enumerated() {
            updatedCharacters[index].speciesNames = []
            for speciesURL in character.species {
                group.enter()
                APIService.fetchSpecies(from: speciesURL) { result in
                    switch result {
                    case .success(let species):
                        updatedCharacters[index].speciesNames.append(species.name)
                    case .failure:
                        break
                    }
                    group.leave()
                }
            }
        }
        group.notify(queue: .main) {
            completion(updatedCharacters)
        }
    }

    func didUpdateFilters(selectedGender: String?, selectedSpecies: Set<String>) {
        self.selectedGender = selectedGender
        self.selectedSpecies = selectedSpecies // selectedSpecies agora armazenará os NOMES das espécies
        applyFilters()
    }
    
    private func applyFilters() {
        filteredCharacters = characters.filter { character in
            // <-- ALTERAR ISTO! (usar character.speciesNames para o filtro)
            let matchesSpecies = selectedSpecies.isEmpty || character.speciesNames.contains(where: { selectedSpecies.contains($0) })
            let matchesGender = selectedGender == nil || selectedGender?.lowercased() == character.gender.lowercased()
            return matchesSpecies && matchesGender
        }
        switch sortBy {
        case "name":
            filteredCharacters.sort {
                sortAscending ? $0.name < $1.name : $0.name > $1.name
            }
        case "year":
            filteredCharacters.sort {
                sortAscending ? $0.birthYear < $1.birthYear : $0.birthYear > $1.birthYear
            }
        default:
            break
        }
        emptyStateImageView.isHidden = !filteredCharacters.isEmpty
        tableView.reloadData()
    }

    // MARK: - Filter UI Setup

    private let filterStackView = UIStackView()

    private func setupFilterControls() {
        filterGearButton.setImage(UIImage(systemName: "line.horizontal.3.decrease"), for: .normal)
        filterGearButton.tintColor = UIColor(named: "SecundaryColor")
        filterGearButton.addTarget(self, action: #selector(filtersButtonTapped), for: .touchUpInside)

        let buttons: [(UIButton, String, Selector)] = [
            (nameSortButton, "NAME", #selector(sortByNameTapped)),
            (yearSortButton, "YEAR", #selector(sortByYearTapped)),
            (ascendingButton, "▲", #selector(sortAscendingTapped)),
            (descendingButton, "▼", #selector(sortDescendingTapped))
        ]

        for (button, title, selector) in buttons {
            button.setTitle(title, for: .normal)
            button.addTarget(self, action: selector, for: .touchUpInside)
            styleFilterButton(button, isSelected: false)
            filterStackView.addArrangedSubview(button)
        }

        styleFilterButton(filterGearButton, isSelected: false)
        filterStackView.addArrangedSubview(filterGearButton)
        filterButton.setImage(UIImage(systemName: "line.3.horizontal.decrease.circle"), for: .normal)
        filterButton.tintColor = UIColor(named: "PrimaryColor")
        filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)

        filterStackView.axis = .horizontal
        filterStackView.distribution = .fillEqually
        filterStackView.spacing = 8
        filterStackView.translatesAutoresizingMaskIntoConstraints = false

        buttons.forEach { filterStackView.addArrangedSubview($0.0) }
        filterStackView.addArrangedSubview(filterButton)

        view.addSubview(filterStackView)
    }

    private func styleFilterButton(_ button: UIButton, isSelected: Bool) {
        let textColor = UIColor(named: isSelected ? "TextOnPrimaryColor" : "SecondaryColor") ?? .black
        let backgroundColor = UIColor(named: isSelected ? "PrimaryColor" : "ThirdColor") ?? .clear
        
        button.setTitleColor(textColor, for: .normal)
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = 8
        button.titleLabel?.font = AppFonts.filteredButtons
    }

    // MARK: - Table View

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(tableView)
        view.addSubview(emptyStateImageView)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCharacters.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let character = filteredCharacters[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = character.name.lowercased()
        cell.textLabel?.font = UIFont(name: "StarJediSpecialEdition", size: 18)
        cell.textLabel?.textColor = UIColor(named: "PrimaryColor")
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.backgroundColor = .clear
        cell.selectionStyle = .none

        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(container)

        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
            container.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
            container.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
            container.heightAnchor.constraint(equalToConstant: 38)
        ])

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedCharacter = filteredCharacters[indexPath.row]
        let detailVC = CharacterDetailsViewController(character: selectedCharacter)
        navigationController?.pushViewController(detailVC, animated: true)
    }

    // MARK: - Constraints

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            filterStackView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
            filterStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            filterStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            filterStackView.heightAnchor.constraint(equalToConstant: 40),

            tableView.topAnchor.constraint(equalTo: filterStackView.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            emptyStateImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateImageView.widthAnchor.constraint(equalToConstant: 200),
            emptyStateImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }

    // MARK: - UISearchBarDelegate

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            filteredCharacters = characters
        } else {
            isSearching = true
            filteredCharacters = characters.filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }
        }
        emptyStateImageView.isHidden = !filteredCharacters.isEmpty
        tableView.reloadData()
    }

    // MARK: - Button Actions

    @objc private func sortByNameTapped() {
        sortBy = "name"
        styleFilterButton(nameSortButton, isSelected: true)
        styleFilterButton(yearSortButton, isSelected: false)
        applyFilters()
    }

    @objc private func sortByYearTapped() {
        sortBy = "year"
        styleFilterButton(nameSortButton, isSelected: false)
        styleFilterButton(yearSortButton, isSelected: true)
        applyFilters()
    }

    @objc private func sortAscendingTapped() {
        sortAscending = true
        styleFilterButton(ascendingButton, isSelected: true)
        styleFilterButton(descendingButton, isSelected: false)
        applyFilters()
    }

    @objc private func sortDescendingTapped() {
        sortAscending = false
        styleFilterButton(ascendingButton, isSelected: false)
        styleFilterButton(descendingButton, isSelected: true)
        applyFilters()
    }

    @objc private func filterButtonTapped() {
        let alert = UIAlertController(title: "Filters", message: nil, preferredStyle: .actionSheet)

        // Gender (sem alterações aqui)
        ["MALE", "FEMALE"].forEach { gender in
            let selected = selectedGender == gender
            let title = selected ? "✓ \(gender)" : gender
            alert.addAction(UIAlertAction(title: title, style: .default) { _ in
                self.selectedGender = selected ? nil : gender
                self.applyFilters()
            })
        }

        // Species (filtragem de alerta)
        // <-- ALTERAR ISTO! (usar character.speciesNames aqui)
        let allSpeciesNames = Set(characters.flatMap { $0.speciesNames }) // Use speciesNames
        for specieName in allSpeciesNames.sorted() {
            let selected = selectedSpecies.contains(specieName)
            let title = selected ? "✓ \(specieName)" : specieName
            alert.addAction(UIAlertAction(title: title, style: .default) { _ in
                if selected {
                    self.selectedSpecies.remove(specieName)
                } else {
                    self.selectedSpecies.insert(specieName)
                }
                self.applyFilters()
            })
        }

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    @objc private func filtersButtonTapped() {
        let filterVC = FilterViewController()
        filterVC.delegate = self
        filterVC.currentGender = selectedGender
        filterVC.currentSpecies = selectedSpecies
        // <-- ALTERAR ISTO! (usar character.speciesNames aqui)
        filterVC.availableSpecies = Array(Set(characters.flatMap { $0.speciesNames })) // Use speciesNames
        filterVC.modalPresentationStyle = .pageSheet
        present(filterVC, animated: true)
    }
}
