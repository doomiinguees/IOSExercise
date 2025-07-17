import UIKit

class ContentViewController: UIViewController {
 
    var contentType: String?  // "CHARACTERS", "SHIPS" ou "PLANETS"

       override func viewDidLoad() {
           super.viewDidLoad()
           view.backgroundColor = .systemBackground

           // Define o título da Navigation Bar
           title = contentType

           // Exemplo de conteúdo com UILabel
           let label = UILabel()
           label.text = "Welcome to \(contentType ?? "UNKNOWN")"
           label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
           label.textAlignment = .center
           label.numberOfLines = 0
           label.translatesAutoresizingMaskIntoConstraints = false

           view.addSubview(label)

           NSLayoutConstraint.activate([
               label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
               label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
               label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
               label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
           ])
       }
}
