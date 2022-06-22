//
//  ContentView.swift
//  SwiftDex
//
//  Created by Brian Corbin on 4/2/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var swiftDexService = SwiftDexService()
    
    var body: some View {
        TabView {
            PokedexView(pokemon: swiftDexService.pokemonDexNumbers, generations: swiftDexService.generations, moveDamageClasses: swiftDexService.moveDamageClasses, moves: swiftDexService.moves, selectedVersionGroup: $swiftDexService.selectedVersionGroup, selectedVersion: $swiftDexService.selectedVersion, selectedPokedex: $swiftDexService.selectedPokedex, selectedMoveDamageClass: $swiftDexService.selectedMoveDamageClass, searchText: $swiftDexService.filterSearchText, speciesVariationsForPokemon: swiftDexService.speciesVariations(for:), alternateFormsForPokemon: swiftDexService.alternateForms(for:), movesForPokemon: swiftDexService.moves(for:))
                .tabItem {
                    Image("icon/tab/dex")
                    Text("SwiftDex")
                }
                
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
