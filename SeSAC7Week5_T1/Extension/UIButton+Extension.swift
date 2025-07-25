import UIKit

extension UIButton {
    func setAttributedTitle(_ title: String, attributes: [NSAttributedString.Key : Any]?) {
        let attrString = NSMutableAttributedString(string: title, attributes: attributes)
        
        self.setAttributedTitle(attrString, for: .normal)
    }
    
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1.0, height: 1.0))
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setFillColor(color.cgColor)
        context.fill(CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0))
        
        let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.setBackgroundImage(backgroundImage, for: state)
    }
}
