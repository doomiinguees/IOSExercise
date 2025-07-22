import UIKit


class PreViewController : UIViewController, UISearchBarDelegate {
    let globalFontName = "StarJediSpecialEdition"
    
    let searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupLogo()
        
        addCustomBackButton()
        setupTitle()
        setCustomFontInSubviews(view)
        setupConstraints()
    }

    func setCustomFontInSubviews(_ view: UIView) {
        for subview in view.subviews {
            if let label = subview as? UILabel {
                label.font = UIFont(name: globalFontName, size: label.font.pointSize)
                label.text = label.text?.lowercased()
            } else if let button = subview as? UIButton {
                button.titleLabel?.font = UIFont(name: globalFontName, size: button.titleLabel?.font.pointSize ?? 17)
                let title = button.title(for: .normal)
                button.setTitle(title?.lowercased(), for: .normal)
            } else if let textField = subview as? UITextField {
                textField.font = UIFont(name: globalFontName, size: textField.font?.pointSize ?? 17)
                textField.text = textField.text?.lowercased()
                if let placeholder = textField.placeholder {
                    textField.attributedPlaceholder = NSAttributedString(
                        string: placeholder.lowercased(),
                        attributes: [.foregroundColor: UIColor.black.withAlphaComponent(0.6)]
                    )
                }
            } else if let textView = subview as? UITextView {
                textView.font = UIFont(name: globalFontName, size: textView.font?.pointSize ?? 17)
                textView.text = textView.text?.lowercased()
            }
            setCustomFontInSubviews(subview)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    public func setupBackground() {
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
    
    public func setupLogo() {
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
    
    public func addCustomBackButton() {
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

    public let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Starships"
        label.font = UIFont(name: "StarJediSpecialEdition", size: 32) ?? UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        label.textColor = UIColor(named: "PrimaryColor")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    public func setupTitle() {
        view.addSubview(titleLabel)
    }
    
    public func setupSearchBar() {
        searchBar.delegate = self

        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.searchBarStyle = .minimal

        // Personalização do UITextField interno
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = UIColor(named: "ThirdColor") ?? .lightGray
            textField.textColor = .black
            textField.clearButtonMode = .whileEditing
            textField.attributedPlaceholder = NSAttributedString(
                string: "Search starships",
                attributes: [.foregroundColor: UIColor.black.withAlphaComponent(0.6)]
            )
            textField.layer.cornerRadius = 15
            textField.clipsToBounds = true

            // Sombra opcional
            textField.layer.shadowColor = UIColor.black.cgColor
            textField.layer.shadowOpacity = 0.2
            textField.layer.shadowOffset = CGSize(width: 0, height: 2)
            textField.layer.shadowRadius = 4
        }

        view.addSubview(searchBar)
    }
    
    public func configureSearchBar(placeholder: String) {
        searchBar.placeholder = placeholder

        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes: [.foregroundColor: UIColor.black.withAlphaComponent(0.6)]
            )
        }
    }
    
    public let emptyStateImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "empty_state"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        return imageView
    }()
    
    private func setupConstraints() {
        view.addSubview(emptyStateImageView)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            emptyStateImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateImageView.widthAnchor.constraint(equalToConstant: 200),
            emptyStateImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }


}
