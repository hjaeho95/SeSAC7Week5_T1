import UIKit

extension UIColor {
    init(hex: String, alpha: Double = 1.0) {
        var hexValue = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hexValue.hasPrefix("#") {
            hexValue.remove(at: hexValue.startIndex)
        } else if hexValue.hasPrefix("0x") {
            hexValue.removeSubrange(hexValue.startIndex..<hexValue.index(hexValue.startIndex, offsetBy: 2))
        }
        
        var rgb: UInt64 = 0
        Scanner(string: hexValue).scanHexInt64(&rgb)
        
        let red = Double((rgb >> 16) & 0xFF) / 255.0
        let green = Double((rgb >> 8) & 0xFF) / 255.0
        let blue = Double(rgb & 0xFF) / 255.0
        
        self.init(
            .sRGB,
            red: red,
            green: green,
            blue: blue,
            opacity: alpha
        )
    }
}
