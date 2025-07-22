import UIKit

class CharacterDetailsViewController: PreViewController {
    
    private let character: Character
    
    // Labels que vão atualizar dinamicamente
    private var homeworldValueLabel: UILabel?
    private var speciesValueLabel: UILabel?
    
    // Valores armazenados
    private var homeworldName: String = "Loading..."
    private var speciesName: String = "Loading..."
    
    init(character: Character) {
        self.character = character
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        setCustomFontInSubviews(view)
        navigationController?.setNavigationBarHidden(true, animated: false)
        titleLabel.text = character.name
        titleLabel.font = AppFonts.home
        
        super.setupBackground()
        super.addCustomBackButton()
        super.setupTitle()
        
        setupCharacterInfo()
        setupConstraints()
        
        fetchHomeworldAndSetupInfo()
        fetchSpeciesAndSetupInfo()
    }
    
    private func fetchHomeworldAndSetupInfo() {
        APIService.fetchPlanet(from: character.homeworld) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let planet):
                self.homeworldName = planet.name
            case .failure:
                self.homeworldName = "Unknown"
            }
            self.updateHomeworldLabel()
        }
    }

    private func fetchSpeciesAndSetupInfo() {
        guard let speciesURL = character.species.first else {
            speciesName = "Unknown"
            updateSpeciesLabel()
            return
        }
        APIService.fetchSpecies(from: speciesURL) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let species):
                self.speciesName = species.name
            case .failure:
                self.speciesName = "Unknown"
            }
            self.updateSpeciesLabel()
        }
    }
    
    private func setupCharacterInfo() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        func section(title: String, items: [(String, String)]) -> UIStackView {
            let sectionStack = UIStackView()
            sectionStack.axis = .vertical
            sectionStack.spacing = 12
            
            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.textColor = UIColor(named: "PrimaryColor")
            titleLabel.font = AppFonts.home
            sectionStack.addArrangedSubview(titleLabel)
            
            for (key, value) in items {
                let rowStack = UIStackView()
                rowStack.axis = .horizontal
                rowStack.distribution = .fillEqually
                rowStack.spacing = 8
                
                let keyLabel = UILabel()
                keyLabel.text = key.uppercased()
                keyLabel.font = AppFonts.body
                keyLabel.textColor = UIColor(named: "PrimaryColor")
                keyLabel.textAlignment = .right
                
                let valueLabel = UILabel()
                valueLabel.text = value
                valueLabel.font = AppFonts.body
                valueLabel.textColor = UIColor(named: "PrimaryColor")
                valueLabel.textAlignment = .left
                
                rowStack.addArrangedSubview(keyLabel)
                rowStack.addArrangedSubview(valueLabel)
                
                sectionStack.addArrangedSubview(rowStack)
            }
            return sectionStack
        }
        
        // Biographical Information
        stackView.addArrangedSubview(section(
            title: "Biographical Information".lowercased(),
            items: [("Born".lowercased(), character.birthYear)]
        ))
        
        // Physical Description (sem species ainda)
        let physicalSection = section(
            title: "Physical Description",
            items: [
                ("Gender", character.gender),
                ("Pronouns", pronounsFromGender(character.gender)),
                ("Height", "\(character.height) meters"),
                ("Mass", "\(character.mass) kilograms")
            ]
        )
        
        stackView.addArrangedSubview(physicalSection)
        
        // Adiciona linha species no physicalSection, vai atualizar depois
        let speciesRow = UIStackView()
        speciesRow.axis = .horizontal
        speciesRow.distribution = .fillEqually
        speciesRow.spacing = 8
        
        let speciesKeyLabel = UILabel()
        speciesKeyLabel.text = "SPECIES"
        speciesKeyLabel.font = AppFonts.body
        speciesKeyLabel.textColor = UIColor(named: "PrimaryColor")
        speciesKeyLabel.textAlignment = .right
        
        let speciesValue = UILabel()
        speciesValue.text = speciesName // Loading...
        speciesValue.font = AppFonts.body
        speciesValue.textColor = UIColor(named: "PrimaryColor")
        speciesValue.textAlignment = .left
        
        speciesRow.addArrangedSubview(speciesKeyLabel)
        speciesRow.addArrangedSubview(speciesValue)
        
        physicalSection.addArrangedSubview(speciesRow)
        self.speciesValueLabel = speciesValue
        
        
        // Homeworld section
        let homeworldSection = UIStackView()
        homeworldSection.axis = .vertical
        homeworldSection.spacing = 12
        
        let homeworldTitle = UILabel()
        homeworldTitle.text = "Homeworld"
        homeworldTitle.textColor = UIColor(named: "PrimaryColor")
        homeworldTitle.font = AppFonts.home
        homeworldSection.addArrangedSubview(homeworldTitle)
        
        let homeworldRow = UIStackView()
        homeworldRow.axis = .horizontal
        homeworldRow.distribution = .fillEqually
        homeworldRow.spacing = 8
        
        let homeworldKeyLabel = UILabel()
        homeworldKeyLabel.text = "HOMEWORLD"
        homeworldKeyLabel.font = AppFonts.body
        homeworldKeyLabel.textColor = UIColor(named: "PrimaryColor")
        homeworldKeyLabel.textAlignment = .right
        
        let homeworldValue = UILabel()
        homeworldValue.text = homeworldName // Loading...
        homeworldValue.font = AppFonts.body
        homeworldValue.textColor = UIColor(named: "PrimaryColor")
        homeworldValue.textAlignment = .left
        
        homeworldRow.addArrangedSubview(homeworldKeyLabel)
        homeworldRow.addArrangedSubview(homeworldValue)
        
        homeworldSection.addArrangedSubview(homeworldRow)
        stackView.addArrangedSubview(homeworldSection)
        
        self.homeworldValueLabel = homeworldValue
        
        // Constraints
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }
    
    private func updateHomeworldLabel() {
        DispatchQueue.main.async {
            self.homeworldValueLabel?.text = self.homeworldName
        }
    }
    
    private func updateSpeciesLabel() {
        DispatchQueue.main.async {
            self.speciesValueLabel?.text = self.speciesName
        }
    }
    
    private func pronounsFromGender(_ gender: String) -> String {
        switch gender.lowercased() {
        case "male": return "He/Him"
        case "female": return "She/Her"
        default: return "They/Them"
        }
    }
    
    private func setupConstraints() {
        guard let backButton = view.subviews.first(where: { $0 is UIButton }) else {
            return
        }
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
