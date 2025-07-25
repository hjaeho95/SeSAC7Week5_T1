import Foundation

extension String {
    func convertDateFormat(innerDateFormat: String, outerDateFormat: String, locale: Locale = .current) -> String {
        
        let innerDateFormatter = DateFormatter()
        innerDateFormatter.dateFormat = innerDateFormat
        let innerDate = innerDateFormatter.date(from: self)
        
        let outerDateFormatter = DateFormatter()
        outerDateFormatter.dateFormat = outerDateFormat
        outerDateFormatter.locale = locale
        let outerDateString = outerDateFormatter.string(from: innerDate ?? Date.now)
        
        return outerDateString
    }
    
    func toDecimalStyle() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        guard let decimal = formatter.string(for: Int(self)) else {
            print("DecimalStyle 변환 실패")
            return ""
        }
        return decimal
    }
}
