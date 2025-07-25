import UIKit

extension UIButton {
    func setAttributedTitle(_ title: String, attributes: [NSAttributedString.Key : Any]?) {
        let attrString = NSMutableAttributedString(string: title, attributes: attributes)
        
        self.setAttributedTitle(attrString, for: .normal)
    }
}
