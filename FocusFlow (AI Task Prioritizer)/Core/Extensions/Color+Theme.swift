//
//  Color+Theme.swift
//  FocusFlow (AI Task Prioritizer)
//
//  Created by WANNASINGH KHANSOPHON on 26/1/2569 BE.
//

import SwiftUI

extension Color {
    // MARK: - Primary Colors
    static let primaryYellow = Color(hex: "#f9f506")
    static let primaryBlue = Color(hex: "#256af4")
    static let primaryGreen = Color(hex: "#0df20d")
    
    // MARK: - Neo Colors
    static let neoYellow = Color(hex: "#FFFF00")
    static let neoCyan = Color(hex: "#22d3ee")
    static let neoMagenta = Color(hex: "#f472b6")
    static let neoLime = Color(hex: "#00FF00")
    static let neoOrange = Color(hex: "#fb923c")
    static let neoPurple = Color(hex: "#a78bfa")
    static let neoPink = Color(hex: "#FF00FF")
    
    // MARK: - Background Colors
    static let backgroundLight = Color(hex: "#f8f8f5")
    static let backgroundDark = Color(hex: "#23220f")
    static let backgroundDarkAlt = Color(hex: "#101622")
    static let backgroundDarkDeep = Color(hex: "#101010")
    
    // MARK: - Text Colors
    static let textPrimary = Color(hex: "#181811")
    static let textSecondary = Color(hex: "#9ca6ba")
    
    // MARK: - Helper
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
