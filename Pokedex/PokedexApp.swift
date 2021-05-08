//
//  PokedexApp.swift
//  Pokedex
//
//  Created by BrianCorbin on 1/24/21.
//

import SwiftUI

@main
struct PokedexApp: App {
    let swiftDexService: SwiftDexService
    let pokemonShowdownService: PokemonShowdownService

    init() {
        swiftDexService = SwiftDexService()
        pokemonShowdownService = PokemonShowdownService(swiftDexService: swiftDexService)
    }

    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(swiftDexService).environmentObject(pokemonShowdownService)
        }
    }
}
