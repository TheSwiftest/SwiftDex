//
//  TypeEffectivenessTable.swift
//  Pokedex
//
//  Created by TempUser on 1/25/21.
//

import Foundation
import SwiftUI

//class TypeEffectiveness {
//    static private let effectivenessTable = [
//        [1, 1, 1, 1, 1, 0.5, 1, 0, 0.5, 1, 1, 1, 1, 1, 1, 1, 1, 1],
//        [2, 1, 0.5, 0.5, 1, 2, 0.5, 0, 2, 1, 1, 1, 1, 0.5, 2, 1, 2, 0.5],
//        [1, 2, 1, 1, 1, 0.5, 2, 1, 0.5, 1, 1, 2, 0.5, 1, 1, 1, 1, 1],
//        [1, 1, 1, 0.5, 0.5, 0.5, 1, 0.5, 0, 1, 1, 2, 1, 1, 1, 1, 1, 2],
//        [1, 1, 0, 2, 1, 2, 0.5, 1, 2, 2, 1, 0.5, 2, 1, 1, 1, 1, 1],
//        [1, 0.5, 2, 1, 0.5, 1, 2, 1, 0.5, 2, 1, 1, 1, 1, 2, 1, 1, 1],
//        [1, 0.5, 0.5, 0.5, 1, 1, 1, 0.5, 0.5, 0.5, 1, 2, 1, 2, 1, 1, 2, 0.5],
//        [0, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 2, 1, 1, 0.5, 1],
//        [1, 1, 1, 1, 1, 2, 1, 1, 0.5, 0.5, 0.5, 1, 0.5, 1, 2, 1, 1, 2],
//        [1, 1, 1, 1, 1, 0.5, 2, 1, 2, 0.5, 0.5, 2, 1, 1, 2, 0.5, 1, 1],
//        [1, 1, 1, 1, 2, 2, 1, 1, 1, 2, 0.5, 0.5, 1, 1, 1, 0.5, 1, 1],
//        [1, 1, 0.5, 0.5, 2, 2, 0.5, 1, 0.5, 0.5, 2, 0.5, 1, 1, 1, 0.5, 1, 1],
//        [1, 1, 2, 1, 0, 1, 1, 1, 1, 1, 2, 0.5, 0.5, 1, 1, 0.5, 1, 1],
//        [1, 2, 1, 2, 1, 1, 1, 1, 0.5, 1, 1, 1, 1, 0.5, 1, 1, 0, 1],
//        [1, 1, 2, 1, 2, 1, 1, 1, 0.5, 0.5, 0.5, 2, 1, 1, 0.5, 2, 1, 1],
//        [1, 1, 1, 1, 1, 1, 1, 1, 0.5, 1, 1, 1, 1, 1, 1, 2, 1, 0],
//        [1, 0.5, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 2, 1, 1, 0.5, 0.5],
//        [1, 2, 1, 0.5, 1, 1, 1, 1, 0.5, 0.5, 1, 1, 1, 1, 1, 2, 2, 1],
//        [1, 1, 2, 1, 2, 1, 1, 1, 0.5, 0.5, 2, 2, 1, 1, 0.5, 2, 1, 1]
//    ]
//}

class TypeEffectiveness {
    static private let effectivenessTable: [TypeEffectiveness.TypeData : [TypeEffectiveness.TypeData : TypeEffectiveness.Effectiveness]] = [
        .normal: [.normal : .normal, .fighting : .normal, .flying: .normal, .poison: .normal, .ground: .normal, .rock: .half, .bug: .normal, .ghost: .none, .steel: .half, .fire: .normal, .water: .normal, .grass: .normal, .electric: .normal, .psychic: .normal, .ice: .normal, .dragon: .normal, .dark: .normal, .fairy: .normal],
        .fighting: [.normal : .double, .fighting : .normal, .flying: .half, .poison: .half, .ground: .normal, .rock: .double, .bug: .half, .ghost: .none, .steel: .double, .fire: .normal, .water: .normal, .grass: .normal, .electric: .normal, .psychic: .half, .ice: .double, .dragon: .normal, .dark: .double, .fairy: .half],
        .flying: [.normal : .normal, .fighting : .double, .flying: .normal, .poison: .normal, .ground: .normal, .rock: .half, .bug: .double, .ghost: .normal, .steel: .half, .fire: .normal, .water: .normal, .grass: .double, .electric: .half, .psychic: .normal, .ice: .normal, .dragon: .normal, .dark: .normal, .fairy: .normal],
        .poison: [.normal : .normal, .fighting : .normal, .flying: .normal, .poison: .half, .ground: .half, .rock: .half, .bug: .normal, .ghost: .half, .steel: .none, .fire: .normal, .water: .normal, .grass: .double, .electric: .normal, .psychic: .normal, .ice: .normal, .dragon: .normal, .dark: .normal, .fairy: .double],
        .ground: [.normal : .normal, .fighting : .normal, .flying: .none, .poison: .double, .ground: .normal, .rock: .double, .bug: .half, .ghost: .normal, .steel: .double, .fire: .double, .water: .normal, .grass: .half, .electric: .double, .psychic: .normal, .ice: .normal, .dragon: .normal, .dark: .normal, .fairy: .normal],
        .rock: [.normal : .normal, .fighting : .half, .flying: .double, .poison: .normal, .ground: .half, .rock: .normal, .bug: .double, .ghost: .normal, .steel: .half, .fire: .double, .water: .normal, .grass: .normal, .electric: .normal, .psychic: .normal, .ice: .double, .dragon: .normal, .dark: .normal, .fairy: .normal],
        .bug: [.normal : .normal, .fighting : .half, .flying: .half, .poison: .half, .ground: .normal, .rock: .normal, .bug: .normal, .ghost: .half, .steel: .half, .fire: .half, .water: .normal, .grass: .double, .electric: .normal, .psychic: .double, .ice: .normal, .dragon: .normal, .dark: .double, .fairy: .half],
        .ghost: [.normal : .none, .fighting : .normal, .flying: .normal, .poison: .normal, .ground: .normal, .rock: .normal, .bug: .normal, .ghost: .double, .steel: .normal, .fire: .normal, .water: .normal, .grass: .normal, .electric: .normal, .psychic: .double, .ice: .normal, .dragon: .normal, .dark: .half, .fairy: .normal],
        .steel: [.normal : .normal, .fighting : .normal, .flying: .normal, .poison: .normal, .ground: .normal, .rock: .double, .bug: .normal, .ghost: .normal, .steel: .half, .fire: .half, .water: .half, .grass: .normal, .electric: .half, .psychic: .normal, .ice: .double, .dragon: .normal, .dark: .normal, .fairy: .double],
        .fire: [.normal : .normal, .fighting : .normal, .flying: .normal, .poison: .normal, .ground: .normal, .rock: .half, .bug: .double, .ghost: .normal, .steel: .double, .fire: .half, .water: .half, .grass: .double, .electric: .normal, .psychic: .normal, .ice: .double, .dragon: .half, .dark: .normal, .fairy: .normal],
        .water: [.normal : .normal, .fighting : .normal, .flying: .normal, .poison: .normal, .ground: .double, .rock: .double, .bug: .normal, .ghost: .normal, .steel: .normal, .fire: .double, .water: .half, .grass: .half, .electric: .normal, .psychic: .normal, .ice: .normal, .dragon: .half, .dark: .normal, .fairy: .normal],
        .grass: [.normal : .normal, .fighting : .normal, .flying: .half, .poison: .half, .ground: .double, .rock: .double, .bug: .half, .ghost: .normal, .steel: .half, .fire: .half, .water: .double, .grass: .half, .electric: .normal, .psychic: .normal, .ice: .normal, .dragon: .half, .dark: .normal, .fairy: .normal],
        .electric: [.normal : .normal, .fighting : .normal, .flying: .double, .poison: .normal, .ground: .none, .rock: .normal, .bug: .normal, .ghost: .normal, .steel: .normal, .fire: .normal, .water: .double, .grass: .half, .electric: .half, .psychic: .normal, .ice: .normal, .dragon: .half, .dark: .normal, .fairy: .normal],
        .psychic: [.normal : .normal, .fighting : .double, .flying: .normal, .poison: .double, .ground: .normal, .rock: .normal, .bug: .normal, .ghost: .normal, .steel: .half, .fire: .normal, .water: .normal, .grass: .normal, .electric: .normal, .psychic: .half, .ice: .normal, .dragon: .normal, .dark: .none, .fairy: .normal],
        .ice: [.normal : .normal, .fighting : .normal, .flying: .double, .poison: .normal, .ground: .double, .rock: .normal, .bug: .normal, .ghost: .normal, .steel: .half, .fire: .half, .water: .half, .grass: .double, .electric: .normal, .psychic: .normal, .ice: .half, .dragon: .double, .dark: .normal, .fairy: .normal],
        .dragon: [.normal : .normal, .fighting : .normal, .flying: .normal, .poison: .normal, .ground: .normal, .rock: .normal, .bug: .normal, .ghost: .normal, .steel: .half, .fire: .normal, .water: .normal, .grass: .normal, .electric: .normal, .psychic: .normal, .ice: .normal, .dragon: .double, .dark: .normal, .fairy: .none],
        .dark: [.normal : .normal, .fighting : .half, .flying: .normal, .poison: .normal, .ground: .normal, .rock: .normal, .bug: .normal, .ghost: .double, .steel: .normal, .fire: .normal, .water: .normal, .grass: .normal, .electric: .normal, .psychic: .double, .ice: .normal, .dragon: .normal, .dark: .half, .fairy: .half],
        .fairy: [.normal : .normal, .fighting : .double, .flying: .normal, .poison: .half, .ground: .normal, .rock: .normal, .bug: .normal, .ghost: .normal, .steel: .half, .fire: .half, .water: .normal, .grass: .normal, .electric: .normal, .psychic: .normal, .ice: .normal, .dragon: .double, .dark: .double, .fairy: .normal]
    ]
    
    static func effectiveness(ofAttackType attackType: TypeData, toDefenceType defenceType: TypeData) -> Effectiveness {
        return self.effectivenessTable[attackType]![defenceType]!
    }
    
    enum TypeData: Int {
        case normal = 1, fighting, flying, poison, ground, rock, bug, ghost, steel, fire,
             water, grass, electric, psychic, ice, dragon, dark, fairy
        case unknown = 10001, shadow = 10002

        func color() -> Color {
            switch self {
            case .fire: return .fire
            case .bug: return .bug
            case .dragon: return .dragon
            case .poison: return .poison
            case .flying: return .flying
            case .normal: return .normal
            case .fairy: return .fairy
            case .ice: return .ice
            case .steel: return .steel
            case .dark: return .dark
            case .ghost: return .ghost
            case .psychic: return .psychic
            case .rock: return .rock
            case .fighting: return .fighting
            case .ground: return .ground
            case .water: return .water
            case .grass: return .grass
            case .electric: return .electric
            case .unknown: return .dark
            case .shadow: return .ghost
            }
        }

        func text() -> String {
            switch self {
            case .unknown: return "Unknown"
            case .shadow: return "Shadow"
            case .normal: return "Normal"
            case .fighting: return "Fighting"
            case .flying: return "Flying"
            case .poison: return "Poison"
            case .ground: return "Ground"
            case .rock: return "Rock"
            case .bug: return "Bug"
            case .ghost: return "Ghost"
            case .steel: return "Steel"
            case .fire: return "Fire"
            case .water: return "Water"
            case .grass: return "Grass"
            case .electric: return "Electric"
            case .psychic: return "Psychic"
            case .ice: return "Ice"
            case .dragon: return "Dragon"
            case .dark: return "Dark"
            case .fairy: return "Fairy"
            }
        }

        func icon() -> Image {
            return Image("icon_\(self.text().lowercased())")
        }

        func damageEffectiveness(from attackType: TypeData) -> Effectiveness {
            return TypeEffectiveness.effectiveness(ofAttackType: attackType, toDefenceType: self)
        }

        static func all() -> [TypeData] {
            return [normal, fighting, flying, poison, ground, rock, bug, ghost, steel, fire, water, grass, electric, psychic, ice, dragon, dark, fairy]
        }
    }

    enum Effectiveness: Double {
        case none = 0.0, quarter = 0.25, half = 0.5, normal = 1.0, double = 2.0, quadruple = 4.0

        func combined(with effectiveness: Effectiveness) -> Effectiveness {
            return Effectiveness(rawValue: self.rawValue * effectiveness.rawValue)!
        }

        func text() -> String {
            switch self {
            case .none: return "0x"
            case .quarter: return "¼x"
            case .half: return "½x"
            case .normal: return "1x"
            case .double: return "2x"
            case .quadruple: return "4x"
            }
        }
    }
}
