import UIKit

final class SeparatorUIView: UIView {
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 1))
        
        backgroundColor = .systemGray
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
