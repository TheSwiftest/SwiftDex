//
//  ContentView.swift
//  SwiftDex
//
//  Created by Brian Corbin on 4/2/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var swiftDexService = SwiftDexService()
    @StateObject var pokemonShowdownService = PokemonShowdownService()
    
    var body: some View {
        TabView {
            PokedexView(pokemon: swiftDexService.pokemonDexNumbers, generations: swiftDexService.generations, moveDamageClasses: swiftDexService.moveDamageClasses, itemPockets: swiftDexService.itemPockets, moves: swiftDexService.moves, items: swiftDexService.items, abilities: swiftDexService.abilities, selectedVersionGroup: $swiftDexService.selectedVersionGroup, selectedVersion: $swiftDexService.selectedVersion, selectedPokedex: $swiftDexService.selectedPokedex, selectedMoveDamageClass: $swiftDexService.selectedMoveDamageClass, selectedItemPocket: $swiftDexService.selectedItemPocket, searchText: $swiftDexService.filterSearchText, speciesVariationsForPokemon: swiftDexService.speciesVariations(for:), alternateFormsForPokemon: swiftDexService.alternateForms(for:), battleOnlyFormsForPokemon: swiftDexService.battleOnlyForms(for:), movesForPokemon: swiftDexService.moves(for:))
                .tabItem {
                    Image("icon/tab/dex")
                    Text("SwiftDex")
                }
            TeamBuilderView().environmentObject(pokemonShowdownService)
                .tabItem {
                    Image("icon/tab/team_builder")
                    Text("Team Builder")
                }
            BattleSimulatorView().environmentObject(pokemonShowdownService)
                .tabItem {
                    Image("icon/tab/battle_sim")
                    Text("Battle Sim")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
