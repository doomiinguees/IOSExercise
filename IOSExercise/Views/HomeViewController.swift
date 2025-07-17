import UIKit


class HomeViewController : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupLogo()
        setupText()
        setupTextAndButtons()
 //       setupButtons()
        
        charactersButtonTapped()
        shipsButtonTapped()
        planetsButtonTapped()

    }
    
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
            background.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupLogo() {
            let logo = UIImageView(image: UIImage(named: "starLogo"))
            logo.translatesAutoresizingMaskIntoConstraints = false
            logo.contentMode = .scaleAspectFit
            view.addSubview(logo)
     
            NSLayoutConstraint.activate([
                logo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                logo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                logo.heightAnchor.constraint(equalToConstant: 60)
            ])
        }
     
    private func setupText() {
      /*  let introLabel = UILabel()
        introLabel.text = """
        HERE YOU WILL FIND
        ALL THE INFORMATION
        YOU NEED  ABOUT
        YOUR FAVORITE
        CHARACTERS, THEIR
        SHIPS AND THEIR
        PLANETS
        """
        introLabel.font = AppFonts.title
        introLabel.textColor = UIColor(named: "PrimaryColor")
        introLabel.textAlignment = .center
        introLabel.numberOfLines = 0
        introLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(introLabel)
 
        let forceLabel = UILabel()
        forceLabel.text = "MAY THE FORCE\nBE WITH YOU"
        forceLabel.font = AppFonts.title
        forceLabel.textColor = UIColor(named: "PrimaryColor")
        forceLabel.textAlignment = .center
        forceLabel.numberOfLines = 0
        forceLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(forceLabel)
 
        NSLayoutConstraint.activate([
            introLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            introLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            introLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
 
            forceLabel.topAnchor.constraint(equalTo: introLabel.bottomAnchor, constant: 20),
            forceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
   */ }
     
    private func setupTextAndButtons() {
        let introLabel = UILabel()
        introLabel.text = """
        HERE YOU WILL FIND
        ALL THE INFORMATION
        YOU NEED  ABOUT
        YOUR FAVORITE
        CHARACTERS, THEIR
        SHIPS AND THEIR
        PLANETS
        """
        introLabel.font = AppFonts.title
        introLabel.textColor = UIColor(named: "PrimaryColor")
        introLabel.textAlignment = .center
        introLabel.numberOfLines = 0

        let forceLabel = UILabel()
        forceLabel.text = "MAY THE FORCE\nBE WITH YOU"
        forceLabel.font = AppFonts.title
        forceLabel.textColor = UIColor(named: "PrimaryColor")
        forceLabel.textAlignment = .center
        forceLabel.numberOfLines = 0

        let charactersButton = createRoundedButton(title: "CHARACTERS")
        charactersButton.addTarget(self, action: #selector(charactersButtonTapped), for: .touchUpInside)

        let shipsButton = createRoundedButton(title: "SHIPS")
        shipsButton.addTarget(self, action: #selector(shipsButtonTapped), for: .touchUpInside)

        let planetsButton = createRoundedButton(title: "PLANETS")
        planetsButton.addTarget(self, action: #selector(planetsButtonTapped), for: .touchUpInside)


        let contentStack = UIStackView(arrangedSubviews: [introLabel, forceLabel, charactersButton, shipsButton, planetsButton])
        contentStack.axis = .vertical
        contentStack.spacing = 16
        contentStack.alignment = .fill
        contentStack.distribution = .equalSpacing
        contentStack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(contentStack)

        NSLayoutConstraint.activate([
            contentStack.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 40),
            contentStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            contentStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        ])
    }

    
    /*private func setupButtons() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
 
        let charactersButton = createRoundedButton(title: "CHARACTERS")
        let shipsButton = createRoundedButton(title: "SHIPS")
        let planetsButton = createRoundedButton(title: "PLANETS")
 
        stackView.addArrangedSubview(charactersButton)
        stackView.addArrangedSubview(shipsButton)
        stackView.addArrangedSubview(planetsButton)
 
        NSLayoutConstraint.activate([
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        ])
    }*/
    @objc private func charactersButtonTapped() {
        openContentView(for: "CHARACTERS")
    }

    @objc private func shipsButtonTapped() {
        openContentView(for: "SHIPS")
    }

    @objc private func planetsButtonTapped() {
        openContentView(for: "PLANETS")
    }
    
    private func openContentView(for contentType: String) {
        let contentVC = ContentViewController()
        contentVC.contentType = contentType
        navigationController?.pushViewController(contentVC, animated: true)
    }


    private func createRoundedButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor(named: "SecundaryColor"), for: .normal)
        button.backgroundColor = UIColor(named: "PrimaryColor")
        button.titleLabel?.font = AppFonts.button
        button.layer.cornerRadius = 25
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }
}

