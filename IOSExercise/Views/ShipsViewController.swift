import UIKit

class ShipsViewController: PreViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let tableView = UITableView()
    private let searchBar = UISearchBar()
    private var starships: [Starship] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(true, animated: false)

        addCustomBackButton()
        setupTitle()
        setupSearchBar()
        setupTableView()
        setupConstraints()
        
        APIService.fetchStarships { [weak self] result in
           switch result {
           case .success(let starships):
               self?.starships = starships
               self?.tableView.reloadData()
           case .failure(let error):
               print("Error searching ships: \(error)")
           }
        }
    }
    
    private func addCustomBackButton() {
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = UIColor(named: "PrimaryColor")
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
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

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Ships"
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
        return starships.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let starship = starships[indexPath.row]
        
        cell.textLabel?.text = starship.name
        cell.textLabel?.textColor = UIColor(named: "PrimaryColor")
        cell.textLabel?.font = UIFont(name: "StarJediSpecialEdition", size: 18) ?? UIFont.systemFont(ofSize: 18)
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.numberOfLines = 0

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

        let selectedStarship = starships[indexPath.row]

        // Por agora apenas imprime no console
        print("Selected ship: \(selectedStarship.name)")

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
