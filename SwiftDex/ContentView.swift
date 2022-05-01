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
            PokedexView(pokemon: swiftDexService.pokemonFiltered, pokemonInfo: swiftDexService.infoForPokemon(with:), generations: swiftDexService.generations, moveDamageClasses: swiftDexService.moveDamageClasses, moves: swiftDexService.movesFiltered, selectedVersionGroup: $swiftDexService.selectedVersionGroup, selectedVersion: $swiftDexService.selectedVersion, selectedPokedex: $swiftDexService.selectedPokedex, searchText: $swiftDexService.filterSearchText)
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
