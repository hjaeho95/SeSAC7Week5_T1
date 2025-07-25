import UIKit

class SeparatorUIView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
