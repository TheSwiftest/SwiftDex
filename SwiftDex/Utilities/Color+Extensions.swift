//
//  Color+Extensions.swift
//  SwiftDex
//
//  Created by Brian Corbin on 4/2/22.
//

import Foundation
import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let alpha, red, green, blue: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (alpha, red, green, blue) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (alpha, red, green, blue) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (alpha, red, green, blue) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (alpha, red, green, blue) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(red) / 255,
            green: Double(green) / 255,
            blue: Double(blue) / 255,
            opacity: Double(alpha) / 255
        )
    }
}

extension Color {
    static let steel = Color("color/type/steel")
    static let ghost = Color("color/type/ghost")
    static let poison = Color("color/type/poison")
    static let water = Color("color/type/water")
    static let flying = Color("color/type/flying")
    static let grass = Color("color/type/grass")
    static let fire = Color("color/type/fire")
    static let fairy = Color("color/type/fairy")
    static let dark = Color("color/type/dark")
    static let dragon = Color("color/type/dragon")
    static let normal = Color("color/type/normal")
    static let ice = Color("color/type/ice")
    static let rock = Color("color/type/rock")
    static let fighting = Color("color/type/fighting")
    static let electric = Color("color/type/electric")
    static let psychic = Color("color/type/psychic")
    static let bug = Color("color/type/bug")
    static let ground = Color("color/type/ground")

    static let hp = Color("color/ev/hp")
    static let atk = Color("color/ev/atk")
    static let def = Color("color/ev/def")
    static let satk = Color("color/ev/satk")
    static let sdef = Color("color/ev/sdef")
    static let spe = Color("color/ev/spe")

    static let male = Color("color/gender/male")
    static let female = Color("color/gender/female")

    static let physicalAttack = Color("color/damage_class/physical")
    static let specialAttack = Color("color/damage_class/special")
    static let statusAttack = Color("color/damage_class/status")
    static let physicalAttackBG = Color("color/damage_class/physical_bg")
    static let specialAttackBG = Color("color/damage_class/special_bg")
    static let statusAttackBG = Color("color/damage_class/status_bg")

    static let dexSearchCategory = Color("color/dex_search_category")
}
