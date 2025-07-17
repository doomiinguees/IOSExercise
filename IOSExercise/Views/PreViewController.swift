import UIKit


    class PreViewController : UIViewController {
    let globalFontName = "StarJediSpecialEdition"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupLogo()
        setCustomFontInSubviews(view)
    }

    func setCustomFontInSubviews(_ view: UIView) {
      for subview in view.subviews {
          if let label = subview as? UILabel {
              label.font = UIFont(name: globalFontName, size: label.font.pointSize)
          } else if let button = subview as? UIButton {
              button.titleLabel?.font = UIFont(name: globalFontName, size: button.titleLabel?.font.pointSize ?? 17)
          } else if let textField = subview as? UITextField {
              textField.font = UIFont(name: globalFontName, size: textField.font?.pointSize ?? 17)
          } else if let textView = subview as? UITextView {
              textView.font = UIFont(name: globalFontName, size: textView.font?.pointSize ?? 17)
          }
          setCustomFontInSubviews(subview) // recursivo
      }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
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

}
