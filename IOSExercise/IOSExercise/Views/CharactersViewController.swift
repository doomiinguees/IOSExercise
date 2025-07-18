import UIKit

class CharactersViewController: PreViewController, UITableViewDelegate, UITableViewDataSource {

    private let tableView = UITableView()
    private let searchBar = UISearchBar()
    private var characters: [Character] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(true, animated: false)

        addCustomBackButton()
        setupTitle()
        setupSearchBar()
        setupTableView()
        setupConstraints()
        
        APIService.fetchCharacters { [weak self] result in
                   switch result {
                   case .success(let characters):
                       self?.characters = characters
                       self?.tableView.reloadData()
                   case .failure(let error):
                       print("Erro ao buscar personagens: \(error)")
                   }
               }

    }

    // MARK: - Back Button

    private func addCustomBackButton() {
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = UIColor(named: "PrimaryColor")
        backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(backButton)

        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }

    @objc private func handleBack() {
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Título

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Characters"
        label.font = UIFont(name: "StarJediSpecialEdition", size: 32) ?? UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        label.textColor = UIColor(named: "PrimaryColor")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private func setupTitle() {
        view.addSubview(titleLabel)
    }

    // MARK: - Search Bar

    private func setupSearchBar() {
        searchBar.searchBarStyle = .default
        searchBar.backgroundImage = UIImage()
        searchBar.translatesAutoresizingMaskIntoConstraints = false

        if let thirdColor = UIColor(named: "ThirdColor") {
            searchBar.backgroundColor = .clear
            let textField = searchBar.searchTextField
            textField.backgroundColor = thirdColor
            textField.layer.cornerRadius = 15
            textField.clipsToBounds = true
            textField.leftView = nil
            textField.leftViewMode = .never
            textField.clearButtonMode = .always
            textField.textColor = .black
            textField.attributedPlaceholder = NSAttributedString(
                string: "Search characters",
                attributes: [.foregroundColor: UIColor.black.withAlphaComponent(0.6)]
            )

            // Sombra
            textField.layer.shadowColor = UIColor.black.cgColor
            textField.layer.shadowOpacity = 0.3
            textField.layer.shadowOffset = CGSize(width: 0, height: 3)
            textField.layer.shadowRadius = 25
        }

        view.addSubview(searchBar)
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
    }

    // MARK: - UITableView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return characters.count
   }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let character = characters[indexPath.row]
        cell.textLabel?.text = character.name
        cell.textLabel?.font = UIFont(name: "StarJediSpecialEdition", size: 18)
        cell.textLabel?.textColor = UIColor(named: "PrimaryColor")
        cell.textLabel?.textAlignment = .center
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

        let selectedCharacter = characters[indexPath.row]

        // Por agora apenas imprime no console
        print("Selected character: \(selectedCharacter.name)")

        // FUTURO: Quando tiveres um CharacterDetailViewController, podes fazer isto:
        // let detailVC = CharacterDetailViewController(characterName: selectedCharacter)
        // navigationController?.pushViewController(detailVC, animated: true)
    }

    
    // MARK: - Constraints

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

}
