import UIKit

protocol FilterViewControllerDelegate: AnyObject {
    func didUpdateFilters(selectedGender: String?, selectedSpecies: Set<String>)
}

class FilterViewController: UIViewController {

    weak var delegate: FilterViewControllerDelegate?

    var availableSpecies: [String] = []
    var currentGender: String?
    var currentSpecies: Set<String> = []

    private let stackView = UIStackView()
    private var genderButtons: [UIButton] = []
    private var speciesButtons: [UIButton] = []
    private let toggleSpeciesButton = UIButton(type: .system)

    private var isSpeciesExpanded: Bool = true
    private var speciesRows: [UIStackView] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "BSBackground")
        view.layer.cornerRadius = 16
        
        let closeButton = UIButton(type: .system)
        closeButton.setTitle("X", for: .normal)
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(closeButton)

        setupLayout()
        toggleSpeciesVisibility()

        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    private func setupLayout() {
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -24)
        ])

        let genderLabel = createSectionLabel("GENDER")
        stackView.addArrangedSubview(genderLabel)

        let genderStack = createButtonRow(["MALE", "FEMALE"], selected: currentGender) { selected in
            self.currentGender = (self.currentGender == selected) ? nil : selected
            self.refreshButtons()
        }
        
        
        genderButtons = genderStack.arrangedSubviews.compactMap { $0 as? UIButton }
        stackView.addArrangedSubview(genderStack)

        let specieLabel = createSectionLabel("SPECIE")
        stackView.addArrangedSubview(specieLabel)

        toggleSpeciesButton.setTitle("Hide Species ▲", for: .normal)
        toggleSpeciesButton.addTarget(self, action: #selector(toggleSpeciesVisibility), for: .touchUpInside)
        styleFilterButton(toggleSpeciesButton, isSelected: false)
        stackView.addArrangedSubview(toggleSpeciesButton)

        speciesRows = createSpeciesRows()
        speciesRows.forEach { stackView.addArrangedSubview($0) }

        let buttonsStack = UIStackView()
        buttonsStack.axis = .horizontal
        buttonsStack.distribution = .fillEqually
        buttonsStack.spacing = 12

        let searchButton = createActionButton("SEARCH", colorName: "PrimaryColor")
        searchButton.addTarget(self, action: #selector(searchTapped), for: .touchUpInside)

        buttonsStack.addArrangedSubview(searchButton)
        stackView.addArrangedSubview(buttonsStack)
    }

    private func createSectionLabel(_ title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = AppFonts.body
        label.textColor = UIColor(named: "PrimaryColor")
        return label
    }

    private func createButtonRow(_ options: [String], selected: String?, action: @escaping (String) -> Void) -> UIStackView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fillEqually

        options.forEach { option in
            let button = UIButton(type: .system)
            button.setTitle(option, for: .normal)
            
            button.layer.cornerRadius = 25
            button.heightAnchor.constraint(equalToConstant: 20).isActive = true
            styleFilterButton(button, isSelected: (selected == option))
            button.addAction(UIAction { _ in action(option) }, for: .touchUpInside)
            stack.addArrangedSubview(button)
        }

        return stack
    }

    private func createSpeciesRows() -> [UIStackView] {
        var rows: [UIStackView] = []
        var currentRow = UIStackView()
        currentRow.axis = .horizontal
        currentRow.spacing = 8
        currentRow.distribution = .fillEqually

        for (index, specie) in availableSpecies.sorted().enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(specie, for: .normal)
            button.layer.cornerRadius = 25
            button.heightAnchor.constraint(equalToConstant: 20).isActive = true

            styleFilterButton(button, isSelected: currentSpecies.contains(specie))
            button.addAction(UIAction { _ in
                if self.currentSpecies.contains(specie) {
                    self.currentSpecies.remove(specie)
                } else {
                    self.currentSpecies.insert(specie)
                }
                self.refreshButtons()
            }, for: .touchUpInside)
            currentRow.addArrangedSubview(button)

            if (index + 1) % 3 == 0 {
                rows.append(currentRow)
                currentRow = UIStackView()
                currentRow.axis = .horizontal
                currentRow.spacing = 8
                currentRow.distribution = .fillEqually
            }
        }

        if !currentRow.arrangedSubviews.isEmpty {
            rows.append(currentRow)
        }

        speciesButtons = rows.flatMap { $0.arrangedSubviews.compactMap { $0 as? UIButton } }

        return rows
    }

    private func styleFilterButton(_ button: UIButton, isSelected: Bool) {
        let textColor = UIColor(named: "SecundaryColor") ?? .black
        let backgroundColor = isSelected
            ? (UIColor(named: "ClickedButton") ?? .clear)
            : (UIColor(named: "Button") ?? .clear)

        button.setTitleColor(textColor, for: .normal)
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = 10
        button.heightAnchor.constraint(equalToConstant: 20).isActive = true
        button.titleLabel?.font = AppFonts.filteredButtons
    }

    private func refreshButtons() {
        genderButtons.forEach {
            guard let title = $0.title(for: .normal) else { return }
            styleFilterButton($0, isSelected: (title == currentGender))
        }
        speciesButtons.forEach {
            guard let title = $0.title(for: .normal) else { return }
            styleFilterButton($0, isSelected: currentSpecies.contains(title))
        }
    }

    private func createActionButton(_ title: String, colorName: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.backgroundColor = UIColor(named: colorName)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 20
        button.titleLabel?.font = AppFonts.body
        return button
    }


    @objc private func resetTapped() {
        currentGender = nil
        currentSpecies.removeAll()
        refreshButtons()
    }

    @objc private func searchTapped() {
        delegate?.didUpdateFilters(selectedGender: currentGender, selectedSpecies: currentSpecies)
        dismiss(animated: true)
    }

    @objc private func toggleSpeciesVisibility() {
        isSpeciesExpanded.toggle()
        speciesRows.forEach { $0.isHidden = !isSpeciesExpanded }

        let title = isSpeciesExpanded ? "Hide Species ▲" : "Show Species ▼"
        toggleSpeciesButton.setTitle(title, for: .normal)
    }

    @objc private func closeTapped() {
        dismiss(animated: true, completion: nil)
    }
}
