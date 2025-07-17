import UIKit
 
extension UIButton {
    func applyPrimaryStyle() {
            self.backgroundColor = UIColor(named: "PrimaryButton")
            self.setTitleColor(UIColor(named: "ButtonText"), for: .normal)
            self.layer.cornerRadius = 10
            self.titleLabel?.font = AppFonts.body
        }
     
    func applySecondaryStyle() {
        self.backgroundColor = .clear
        self.setTitleColor(UIColor(named: "SecondaryText"), for: .normal)
        self.layer.borderColor = UIColor(named: "SecondaryText")?.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 10
        self.titleLabel?.font = AppFonts.body
    }
}
