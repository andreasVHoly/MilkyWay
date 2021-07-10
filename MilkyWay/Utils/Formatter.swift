import Foundation

class Formatter {
    private static let inputFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter
    }()

    private static let outputFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM, YYYY"
        return formatter
    }()

    static func format(string: String) -> Date? {
        inputFormatter.date(from: string)
    }

    static func format(date: Date) -> String {
        outputFormatter.string(from: date)
    }
}
