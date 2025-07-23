import UIKit

class CharacterDetailsViewController: PreViewController {
    
    private let character: Character
    
    private var homeworldValueLabel: UILabel?
    private var speciesValueLabel: UILabel?
    
    private var homeworldName: String = "loading..."
    private var speciesName: String = "loading..."
    
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
        titleLabel.text = character.name.lowercased()
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
                self.homeworldName = planet.name.lowercased()
            case .failure:
                self.homeworldName = "unknown"
            }
            self.updateHomeworldLabel()
        }
    }

    private func fetchSpeciesAndSetupInfo() {
        guard let speciesURL = character.species.first else {
            speciesName = "unknown"
            updateSpeciesLabel()
            return
        }
        APIService.fetchSpecies(from: speciesURL) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let species):
                self.speciesName = species.name.lowercased()
            case .failure:
                self.speciesName = "unknown"
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
            titleLabel.text = title.lowercased()
            titleLabel.textColor = UIColor(named: "PrimaryColor")
            titleLabel.font = AppFonts.home
            sectionStack.addArrangedSubview(titleLabel)
            
            for (key, value) in items {
                let rowStack = UIStackView()
                rowStack.axis = .horizontal
                rowStack.distribution = .fillEqually
                rowStack.spacing = 8
                
                let keyLabel = UILabel()
                keyLabel.text = key.lowercased()
                keyLabel.font = AppFonts.body
                keyLabel.textColor = UIColor(named: "PrimaryColor")
                keyLabel.textAlignment = .right
                
                let valueLabel = UILabel()
                valueLabel.text = value.lowercased()
                valueLabel.font = AppFonts.body
                valueLabel.textColor = UIColor(named: "PrimaryColor")
                valueLabel.textAlignment = .left
                
                rowStack.addArrangedSubview(keyLabel)
                rowStack.addArrangedSubview(valueLabel)
                
                sectionStack.addArrangedSubview(rowStack)
            }
            return sectionStack
        }
        
        stackView.addArrangedSubview(section(
            title: "biographical information",
            items: [("born", character.birthYear)]
        ))
        
        let physicalSection = section(
            title: "physical description",
            items: [
                ("gender", character.gender),
                ("pronouns", pronounsFromGender(character.gender)),
                ("height", "\(character.height) meters"),
                ("mass", "\(character.mass) kilograms")
            ]
        )
        stackView.addArrangedSubview(physicalSection)
        
        let speciesRow = UIStackView()
        speciesRow.axis = .horizontal
        speciesRow.distribution = .fillEqually
        speciesRow.spacing = 8
        
        let speciesKeyLabel = UILabel()
        speciesKeyLabel.text = "species".lowercased()
        speciesKeyLabel.font = AppFonts.body
        speciesKeyLabel.textColor = UIColor(named: "PrimaryColor")
        speciesKeyLabel.textAlignment = .right
        
        let speciesValue = UILabel()
        speciesValue.text = speciesName
        speciesValue.font = AppFonts.body
        speciesValue.textColor = UIColor(named: "PrimaryColor")
        speciesValue.textAlignment = .left
        
        speciesRow.addArrangedSubview(speciesKeyLabel)
        speciesRow.addArrangedSubview(speciesValue)
        physicalSection.addArrangedSubview(speciesRow)
        self.speciesValueLabel = speciesValue
        
        let homeworldSection = UIStackView()
        homeworldSection.axis = .vertical
        homeworldSection.spacing = 12
        
        let homeworldTitle = UILabel()
        homeworldTitle.text = "homeworld"
        homeworldTitle.textColor = UIColor(named: "PrimaryColor")
        homeworldTitle.font = AppFonts.home
        homeworldSection.addArrangedSubview(homeworldTitle)
        
        let homeworldRow = UIStackView()
        homeworldRow.axis = .horizontal
        homeworldRow.distribution = .fillEqually
        homeworldRow.spacing = 8
        
        let homeworldKeyLabel = UILabel()
        homeworldKeyLabel.text = "homeworld"
        homeworldKeyLabel.font = AppFonts.body
        homeworldKeyLabel.textColor = UIColor(named: "PrimaryColor")
        homeworldKeyLabel.textAlignment = .right
        
        let homeworldValue = UILabel()
        homeworldValue.text = homeworldName
        homeworldValue.font = AppFonts.body
        homeworldValue.textColor = UIColor(named: "PrimaryColor")
        homeworldValue.textAlignment = .left
        
        homeworldRow.addArrangedSubview(homeworldKeyLabel)
        homeworldRow.addArrangedSubview(homeworldValue)
        
        homeworldSection.addArrangedSubview(homeworldRow)
        stackView.addArrangedSubview(homeworldSection)
        
        self.homeworldValueLabel = homeworldValue
        
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
        case "male": return "he/him"
        case "female": return "she/her"
        default: return "they/them"
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -24),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
