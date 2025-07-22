import UIKit

class PlanetsViewController: PreViewController, UITableViewDelegate, UITableViewDataSource {

    private let tableView = UITableView()
    private var planets: [Planet] = []
    private var filteredPlanets: [Planet] = []
    private var isSearching: Bool = false


    override func viewDidLoad() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        titleLabel.text = "Planets"
        configureSearchBar(placeholder: "Search planets")
        
        super.setupBackground()
        super.setupLogo()
        super.addCustomBackButton()
        super.setupTitle()
        super.setupSearchBar()
        
        setupTableView()
        setupConstraints()
        /*APIService.fetchPlanets { [weak self] result in
            switch result {
            case .success(let planets):
                self?.planets = planets
                self?.filteredPlanets = planets // importante
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print("Error searching planets: \(error)")
            }
        }*/
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

    // MARK: - UITableView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPlanets.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let planet = filteredPlanets[indexPath.row]
        cell.textLabel?.text = planet.name
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

        let selectedPlanet = filteredPlanets[indexPath.row]

        // Por agora apenas imprime no console
        print("Selected planet: \(selectedPlanet.name)")

        // FUTURO: Quando tiveres um PlanetDetailViewController, podes fazer isto:
        // let detailVC = PlanetDetailViewController(planetName: selectedPlanet)
        // navigationController?.pushViewController(detailVC, animated: true)
    }

    
    // MARK: - Constraints

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emptyStateImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateImageView.widthAnchor.constraint(equalToConstant: 200),
            emptyStateImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            filteredPlanets = planets
        } else {
            isSearching = true
            filteredPlanets = planets.filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }
        }
        emptyStateImageView.isHidden = !filteredPlanets.isEmpty
        tableView.reloadData()
    }
}
