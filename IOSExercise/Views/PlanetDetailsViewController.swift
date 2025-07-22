import UIKit

class PlanetDetailsViewController: PreViewController {
    
    private var planet: Planet

    init(planet: Planet) {
        self.planet = planet
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        setCustomFontInSubviews(view)
        navigationController?.setNavigationBarHidden(true, animated: false)
        titleLabel.text = planet.name.lowercased()
        titleLabel.font = AppFonts.home
        
        super.setupBackground()
        super.addCustomBackButton()
        super.setupTitle()

        setupConstraints()
        
        APIService.fetchPlanet(from: planet.url) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let planet):
                self.planet = planet
                DispatchQueue.main.async {
                    self.setupPlanetInfo()
                }
            case .failure(let error):
                print("failed to fetch planet: \(error.localizedDescription)")
            }
        }
    }

    private func setupPlanetInfo() {
        titleLabel.text = planet.name.lowercased()
        titleLabel.font = AppFonts.home

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        func infoRow(key: String, value: String) -> UIStackView {
            let row = UIStackView()
            row.axis = .horizontal
            row.spacing = 8
            row.alignment = .top
            row.distribution = .fill

            let keyLabel = UILabel()
            keyLabel.text = key.uppercased()
            keyLabel.font = AppFonts.body
            keyLabel.textColor = UIColor(named: "PrimaryColor")
            keyLabel.textAlignment = .right
            keyLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
            
            keyLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            keyLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

            let valueLabel = UILabel()
            valueLabel.text = value
            valueLabel.font = AppFonts.body
            valueLabel.textColor = UIColor(named: "PrimaryColor")
            valueLabel.textAlignment = .left
            valueLabel.numberOfLines = 0
            valueLabel.lineBreakMode = .byWordWrapping

            valueLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
            valueLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

            row.addArrangedSubview(keyLabel)
            row.addArrangedSubview(valueLabel)
            return row
        }

        let details = [
            ("climate", planet.climate),
            ("terrain", planet.terrain),
            ("population", planet.population),
            ("gravity", planet.gravity),
            ("diameter", planet.diameter),
            ("rotation period", planet.rotationPeriod),
            ("orbital period", planet.orbitalPeriod),
            ("surface water", planet.surfaceWater)
        ]

        for (key, value) in details {
            stackView.addArrangedSubview(infoRow(key: key, value: value))
        }

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
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
