//
//  Generation.swift
//  SwiftDex
//
//  Created by Brian Corbin on 4/14/22.
//

import SwiftUI

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
