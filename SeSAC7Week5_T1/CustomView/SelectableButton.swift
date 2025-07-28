import UIKit

final class SelectableButton: UIButton {
    
    init(_ title: String) {
        super.init(frame: .zero)
        
        var config = UIButton.Configuration.filled()
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        config.cornerStyle = .large
        config.background.strokeColor = .white
        config.background.strokeWidth = 1
        configuration = config
        
        configurationUpdateHandler = { button in
            var updatedConfig = button.configuration
            updatedConfig?.baseBackgroundColor = button.isSelected ? .white : .black
            updatedConfig?.baseForegroundColor = button.isSelected ? .black : .white
            updatedConfig?.attributedTitle = AttributedString(title, attributes: AttributeContainer([
                .font: UIFont.systemFont(ofSize: 14)
            ]))
            button.configuration = updatedConfig
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
