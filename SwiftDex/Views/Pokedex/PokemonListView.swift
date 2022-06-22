//
//  PokemonListView.swift
//  SwiftDex
//
//  Created by Brian Corbin on 4/14/22.
//

import SwiftUI

struct PokemonListView: View {
    let pokemonDexNumbers: [PokemonDexNumber]
    @Binding var pokemonToShow: Pokemon?
    
    var body: some View {
        LazyVStack(spacing: 10) {
            ForEach(pokemonDexNumbers) { pokemonDexNumber in
                PokemonSummaryView(pokemon: pokemonDexNumber.pokemon!, pokedexNumber: pokemonDexNumber.pokedexNumber, showVersionView: false, showVersionSelectionView: .constant(false))
                    .padding(.horizontal, 10)
                    .onTapGesture {
                        pokemonToShow = pokemonDexNumber.pokemon!
                    }
            }
        }
        .padding(.top, 10)
    }
}

struct PokemonListView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonListView(pokemonDexNumbers: Array(testRealm.objects(PokemonDexNumber.self).filter({$0.pokedex?.id == 1}).filter({$0.pokedexNumber < 10})), pokemonToShow: .constant(nil))
            .previewLayout(.sizeThatFits)
    }
}
