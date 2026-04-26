import SwiftUI

extension Color {
    static let trustBlue = Color(red: 18/255, green: 112/255, blue: 196/255)
    static let tealGreen = Color(red: 46/255, green: 158/255, blue: 138/255)
    static let warmOrange = Color(red: 255/255, green: 156/255, blue: 30/255)
    static let successGreen = Color(red: 56/255, green: 186/255, blue: 89/255)
    static let dangerRed = Color(red: 230/255, green: 56/255, blue: 56/255)
    static let bgLight = Color(red: 247/255, green: 247/255, blue: 250/255)
    static let cardWhite = Color.white
    static let textPrimary = Color(red: 33/255, green: 33/255, blue: 41/255)
    static let textSecondary = Color(red: 115/255, green: 115/255, blue: 128/255)

    init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        self.init(
            red: Double((rgb & 0xFF0000) >> 16) / 255.0,
            green: Double((rgb & 0x00FF00) >> 8) / 255.0,
            blue: Double(rgb & 0x0000FF) / 255.0
        )
    }
}
