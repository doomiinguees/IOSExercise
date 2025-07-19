import UIKit

class CharactersViewController: PreViewController, UITableViewDelegate, UITableViewDataSource {

    private let tableView = UITableView()
    private let searchBar = UISearchBar()
    private let refreshControl = UIRefreshControl()

    private var characters: [Character] = []
    private var filteredCharacters: [Character] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(true, animated: false)

        addCustomBackButton()
        setupTitle()
        setupSearchBar()
        setupTableView()
        setupEmptyStateView()
        setupConstraints()

        if let lastQuery = UserDefaults.standard.string(forKey: "LastSearchQuery") {
            searchBar.text = lastQuery
        }

        fetchCharacters()
    }

    // MARK: - Fetch Characters

    private func fetchCharacters() {
        APIService.fetchCharacters { [weak self] result in
            DispatchQueue.main.async {
                self?.refreshControl.endRefreshing()
            }

            switch result {
            case .success(let characters):
                guard let self = self else { return }
                self.characters = characters

                let searchText = self.searchBar.text?.lowercased() ?? ""
                self.filteredCharacters = searchText.isEmpty
                    ? characters
                    : characters.filter { $0.name.lowercased().contains(searchText) }

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.updateEmptyState()
                }

            case .failure(let error):
                print("Error fetching Characters: \(error)")
            }
        }
    }

    // MARK: - UI Setup

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

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Characters"
        label.font = AppFonts.title
        label.textAlignment = .center
        label.textColor = UIColor(named: "PrimaryColor")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private func setupTitle() {
        view.addSubview(titleLabel)
    }

    private func setupSearchBar() {
        searchBar.searchBarStyle = .default
        searchBar.backgroundImage = UIImage()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self

        if let thirdColor = UIColor(named: "ThirdColor") {
            let textField = searchBar.searchTextField
            textField.backgroundColor = thirdColor
            textField.layer.cornerRadius = 15
            textField.clipsToBounds = true
            textField.leftView = nil
            textField.leftViewMode = .never
            textField.clearButtonMode = .always
            textField.textColor = .black
            textField.font = AppFonts.body
            textField.attributedPlaceholder = NSAttributedString(
                string: "Search characters",
                attributes: [.foregroundColor: UIColor.black.withAlphaComponent(0.6), .font: AppFonts.body ?? .systemFont(ofSize: 16)]
            )

            textField.layer.shadowColor = UIColor.black.cgColor
            textField.layer.shadowOpacity = 0.3
            textField.layer.shadowOffset = CGSize(width: 0, height: 3)
            textField.layer.shadowRadius = 25
        }

        view.addSubview(searchBar)
    }

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshCharacters), for: .valueChanged)

        view.addSubview(tableView)
    }

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

        view.addSubview(emptyStateView)

        NSLayoutConstraint.activate([
            emptyStateView.topAnchor.constraint(equalTo: tableView.topAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: tableView.bottomAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: tableView.trailingAnchor)
        ])
    }

    // MARK: - Empty State View

    private let emptyStateView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true

        let imageView = UIImageView(image: UIImage(named: "empty_state"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tag = 1

        let label = UILabel()
        label.text = "No characters found"
        label.textAlignment = .center
        label.font = AppFonts.subtitle
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.tag = 2

        let button = UIButton(type: .system)
        button.setTitle("Try Again", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = AppFonts.button
        button.backgroundColor = UIColor(named: "PrimaryColor")
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(nil, action: #selector(refreshCharacters), for: .touchUpInside)
        button.tag = 3

        view.addSubview(imageView)
        view.addSubview(label)
        view.addSubview(button)

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            imageView.widthAnchor.constraint(equalToConstant: 120),
            imageView.heightAnchor.constraint(equalToConstant: 120),

            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 12),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 16),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.widthAnchor.constraint(equalToConstant: 140),
            button.heightAnchor.constraint(equalToConstant: 40)
        ])

        return view
    }()

    private func setupEmptyStateView() {
        // Already called in setupConstraints
    }

    private func updateEmptyState() {
        let isEmpty = filteredCharacters.isEmpty
        emptyStateView.isHidden = !isEmpty
        tableView.isHidden = isEmpty
    }

    // MARK: - TableView DataSource & Delegate

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCharacters.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let character = filteredCharacters[indexPath.row]

        cell.textLabel?.text = character.name
        cell.textLabel?.font = AppFonts.body
        cell.textLabel?.textColor = UIColor(named: "PrimaryColor")
        cell.textLabel?.textAlignment = .center
        cell.backgroundColor = .clear
        cell.selectionStyle = .none

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedCharacter = filteredCharacters[indexPath.row]
        print("Selected character: \(selectedCharacter.name)")
    }

    // MARK: - Refresh

    @objc private func refreshCharacters() {
        fetchCharacters()
    }
}

// MARK: - UISearchBarDelegate

extension CharactersViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredCharacters = characters.filter {
            $0.name.lowercased().contains(searchText.lowercased())
        }
        UserDefaults.standard.setValue(searchText, forKey: "LastSearchQuery")
        tableView.reloadData()
        updateEmptyState()
    }
}
