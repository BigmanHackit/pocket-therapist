//
//  TeamsColors.swift
//  Pocket Therapist
//
//  Created by Firebrand Dev on 16/07/2025.
//

import Foundation
import SwiftUI

struct TeamsColors {
    static let primary = Color(hex: "6264A7")
    static let background = LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .topLeading, endPoint: .bottomTrailing)
    static let surface = Color.white
    static let userBubble = Color(hex: "6264A7")
    static let aiBubble = Color(hex: "F0F0F0")
    static let text = Color(hex: "323130")
    static let textSecondary = Color(hex: "605E5C")
    static let accent = Color(hex: "6264A7")
    static let success = Color(hex: "0B6A0B")
    static let warning = Color(hex: "FFA500")
    static let border = Color(hex: "E1DFDD")
    static let hover = Color(hex: "F3F2F1")
}

extension Color {
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
