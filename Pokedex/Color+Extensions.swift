//
//  Color+Extensions.swift
//  Pokedex
//
//  Created by TempUser on 1/24/21.
//

import Foundation
import SwiftUI

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

extension Color {
    static let steel = Color("steel")
    static let ghost = Color("ghost")
    static let poison = Color("poison")
    static let water = Color("water")
    static let flying = Color("flying")
    static let grass = Color("grass")
    static let fire = Color("fire")
    static let fairy = Color("fairy")
    static let dark = Color("dark")
    static let dragon = Color("dragon")
    static let normal = Color("normal")
    static let ice = Color("ice")
    static let rock = Color("rock")
    static let fighting = Color("fighting")
    static let electric = Color("electric")
    static let psychic = Color("psychic")
    static let bug = Color("bug")
    static let ground = Color("ground")
    
    static let hp = Color("hp")
    static let atk = Color("atk")
    static let def = Color("def")
    static let satk = Color("satk")
    static let sdef = Color("sdef")
    static let spe = Color("spe")
    
    static let male = Color("male")
    static let female = Color("female")
    
    static let physicalAttack = Color("attack_type_physical")
    static let specialAttack = Color("attack_type_special")
    static let statusAttack = Color("attack_type_status")
    static let physicalAttackBG = Color("attack_type_physical_bg")
    static let specialAttackBG = Color("attack_type_special_bg")
    static let statusAttackBG = Color("attack_type_status_bg")
    
    static let dexSearchCategory = Color("dex_search_category")
}
