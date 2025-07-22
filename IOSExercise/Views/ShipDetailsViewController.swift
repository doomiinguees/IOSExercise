import UIKit

class ShipDetailsViewController: PreViewController {
    
    private var ship: Starship

    init(ship: Starship) {
        self.ship = ship
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        setCustomFontInSubviews(view)
        navigationController?.setNavigationBarHidden(true, animated: false)
        titleLabel.text = ship.name.lowercased()
        titleLabel.font = AppFonts.home
        
        super.setupBackground()
        super.addCustomBackButton()
        super.setupTitle()

        setupConstraints()
        
        /*APIService.fetchPlanet(from: planet.url) { [weak self] result in
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
        }*/
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
