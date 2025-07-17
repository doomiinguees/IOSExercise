import UIKit

class ViewController: UIViewController {
    
    // MARK: - Properties
    var characters: [Character] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackground()
        setupUI()
        fetchCharacters()
    }
    
    // MARK: - Setup Methods
    
    private func setupBackground() {
        let background = UIImageView(image: UIImage(named: "space"))
        background.contentMode = .scaleAspectFill
        background.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(background)
        view.sendSubviewToBack(background)
        
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: view.topAnchor),
            background.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            background.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            background.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    private func setupUI() {
        // Title
        let titleLabel = UILabel()
        titleLabel.text = "CHARACTERS"
        titleLabel.font = AppFonts.title
        titleLabel.textColor = UIColor(named: "PrimaryText")
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)
        
        // Search Bar
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search..."
        searchBar.searchBarStyle = .minimal
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)
        
        // Primary Button
        let primaryButton = UIButton()
        primaryButton.setTitle("Confirmar", for: .normal)
        primaryButton.applyPrimaryStyle()
        primaryButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(primaryButton)
        
        // Secondary Button
        let secondaryButton = UIButton()
        secondaryButton.setTitle("Cancelar", for: .normal)
        secondaryButton.applySecondaryStyle()
        secondaryButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(secondaryButton)
        
        // Constraints
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            primaryButton.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 40),
            primaryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            primaryButton.widthAnchor.constraint(equalToConstant: 200),
            primaryButton.heightAnchor.constraint(equalToConstant: 44),
            
            secondaryButton.topAnchor.constraint(equalTo: primaryButton.bottomAnchor, constant: 20),
            secondaryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            secondaryButton.widthAnchor.constraint(equalToConstant: 200),
            secondaryButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    // MARK: - API Call
    private func fetchCharacters() {
        APIService.shared.fetchCharacters { result in
            switch result {
            case .success(let characters):
                self.characters = characters
                print("✅ \(characters.count) personagens carregados.")
                // Aqui podes atualizar a UI, ex: tableView.reloadData()
            case .failure(let error):
                print("❌ Erro ao carregar personagens: \(error.localizedDescription)")
            }
        }
    }
}
