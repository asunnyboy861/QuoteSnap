import Foundation

extension Date {
    var formattedShort: String {
        formatted(date: .abbreviated, time: .omitted)
    }

    var formattedMedium: String {
        formatted(date: .long, time: .omitted)
    }

    var formattedNumeric: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: self)
    }
}
