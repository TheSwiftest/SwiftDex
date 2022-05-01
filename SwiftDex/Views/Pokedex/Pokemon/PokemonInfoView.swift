//
//  PokemonInfoView.swift
//  SwiftDex
//
//  Created by Brian Corbin on 4/4/22.
//

import SwiftUI

struct PokemonInfoView: View {
    let pokemonInfo: PokemonInfo
    @Binding var selectedPokemon: PokemonSummary?
    
    @State private var showVersionSelectionView: Bool = false
    
    var body: some View {
        VStack(spacing: 5) {
            PokemonSummaryView(summary: pokemonInfo.summary, showVersionView: true, showVersionSelectionView: $showVersionSelectionView)
            TabView {
                PokemonBasicInfoView(basicInfo: pokemonInfo.basicInfo, color: pokemonInfo.color, selectedPokemon: $selectedPokemon)
                    .tabItem {
                        Image(systemName: "info.circle")
                        Text("Info")
                    }
                MovesInfoView(info: pokemonInfo.moveInfo)
                    .tabItem {
                        Image("icon/tab/moves")
                        Text("Moves")
                    }
                PokemonBreedingInfoView(breedingInfo: pokemonInfo.breedingInfo, color: pokemonInfo.color)
                    .tabItem {
                        Image("icon/tab/breeding")
                        Text("Breeding")
                    }
            }
            .accentColor(pokemonInfo.color)
        }
    }
}

struct PokemonInfoView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonInfoView(pokemonInfo: bulbasaurPokemonInfo, selectedPokemon: .constant(bulbasaurSummary))
    }
}
