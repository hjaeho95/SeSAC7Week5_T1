import Foundation

extension Date {
    func formattedString(format: String) -> String {
        let date = self
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let stringDate = dateFormatter.string(from: date)
        
        return stringDate
    }
}
