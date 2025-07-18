import UIKit


class HomeViewController : PreViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupText()
        setupTextAndButtons()
 //       setupButtons()
        
    //    charactersButtonTapped()
      //  shipsButtonTapped()
       //	 planetsButtonTapped()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    private func setupText() {}
     
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
        let vc = CharactersViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func shipsButtonTapped() {
        let vc = ShipsViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func planetsButtonTapped() {
        let vc = PlanetsViewController()
        navigationController?.pushViewController(vc, animated: true)
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

