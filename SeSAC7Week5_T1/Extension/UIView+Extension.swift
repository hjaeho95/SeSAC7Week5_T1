import UIKit

extension UIView {
    func addSubview(_ views: UIView...) {
        views.forEach { view in
            addSubview(view)
        }
    }
}
