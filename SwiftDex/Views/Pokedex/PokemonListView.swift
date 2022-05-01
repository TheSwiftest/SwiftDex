//
//  PokemonListView.swift
//  SwiftDex
//
//  Created by Brian Corbin on 4/14/22.
//

import SwiftUI

struct PokemonListView: View {
    let pokemon: [PokemonSummary]
    @Binding var pokemonToShow: PokemonSummary?
    
    var body: some View {
        LazyVStack(spacing: 10) {
            ForEach(pokemon.sorted(by: {$0.pokedexNumber < $1.pokedexNumber})) { pokemonSummary in
                PokemonSummaryView(summary: pokemonSummary, showVersionView: false, showVersionSelectionView: .constant(false))
                    .padding(.horizontal, 10)
                    .onTapGesture {
                        pokemonToShow = pokemonSummary
                    }
            }
        }
        .padding(.top, 10)
    }
}

struct PokemonListView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonListView(pokemon: testPokemonSummaries, pokemonToShow: .constant(nil))
            .previewLayout(.sizeThatFits)
    }
}
