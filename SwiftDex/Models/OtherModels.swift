//
//  Generation.swift
//  SwiftDex
//
//  Created by Brian Corbin on 4/14/22.
//

import SwiftUI

struct GenerationInfo: Identifiable {
    let id: Int
    let identifier: String
    let name: String
    let versionGroups: [VersionGroupInfo]
}

struct VersionInfo: Identifiable {
    let id: Int
    let name: String
    let identifier: String
    
    var color: Color {
        return Color("color/version/\(identifier)")
    }
}

struct VersionGroupInfo: Identifiable {
    let id: Int
    let identifier: String
    let order: Int
    
    let versions: [VersionInfo]
    let pokedexes: [PokedexInfo]
}

struct PokedexInfo: Identifiable, Equatable {
    let id: Int
    let identifier: String
    let name: String
}

struct MoveDamageClassInfo: Identifiable, Equatable {
    let id: Int
    let identifier: String
    let name: String
}

enum DexCategory: String, Hashable {
    case pokémon, moves, items, abilities

    func icon() -> Image {
        switch self {
        case .pokémon: return Image("icon/dex_type/pokemon")
        case .moves: return Image("icon/dex_type/moves")
        case .items: return Image("icon/dex_type/items")
        case .abilities: return Image("icon/dex_type/abilities")
        }
    }

    static func all(except: DexCategory? = nil) -> [DexCategory] {
        var included = [DexCategory]()
        if except != .pokémon { included.append(.pokémon) }
        if except != .moves { included.append(.moves) }
        if except != .items { included.append(.items) }
        if except != .abilities { included.append(.abilities) }
        return included
    }
}

struct PokemonFormInfo: Identifiable {
    let identifier: String
    let formIdentifier: String?
    let id: Int
    let name: String
    let isDefault: Bool
    let isBattleOnly: Bool
    let isMega: Bool
    
    var sprite: Image {
        return Image("sprite/pokemon/\(id)-\(formIdentifier ?? "")")
    }
}

struct PokemonInfo: Identifiable {
    var id: Int {
        return summary.id
    }
    
    let summary: PokemonSummary
    let basicInfo: PokemonBasicInfo
    let breedingInfo: PokemonBreedingInfo
    let moveInfo: PokemonMovesInfo
    
    var color: Color {
        return summary.types[0].typeData.color()
    }
}

struct PokemonSummary: Identifiable {
    struct PokemonType {
        let typeData: TypeEffectiveness.TypeData
        let name: String
    }
    
    let id: Int
    let speciesId: Int
    let pokedexNumber: Int
    let name: String
    let types: [PokemonType]
    let versionName: String
    let formIdentifier: String?
    
    var sprite: Image {
        guard let formIdentifier = formIdentifier else {
            return Image("sprite/pokemon/\(speciesId)")
        }
        
        return Image("sprite/pokemon/\(speciesId)-\(formIdentifier)")
    }
}
