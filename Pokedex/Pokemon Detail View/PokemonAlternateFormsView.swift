//
//  PokemonAlternateFormsView.swift
//  Pokedex
//
//  Created by TempUser on 1/30/21.
//

import SwiftUI
import Kingfisher

struct PokemonAlternateFormsView: View {
    
    let species: PokemonSpecies
    @Binding var selectedPokemon: Pokemon
    @Binding var selectedForm: PokemonForm
    let selectedVersionGroup: VersionGroup
    
    var validDefaultPokemonForms: [PokemonForm] {
        return selectedPokemon.species!.pokemon.compactMap({$0.defaultForm}).filter { (form) -> Bool in
            return form.introducedInVersionGroup!.generation!.id <= selectedVersionGroup.generation!.id
        }
    }
    
    var validPokemon: [Pokemon] {
        return validDefaultPokemonForms.compactMap({$0.pokemon})
    }
    
    var body: some View {
        VStack {
            if validPokemon.count > 1 {
                PokemonDetailSectionHeader(text: "Alternate Forms")
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], alignment: .center) {
                    ForEach(validPokemon, id:\.id) { pokemon in
                        VStack {
                            Text(pokemon.name)
                                .minimumScaleFactor(0.5)
                                .lineLimit(1)
                            Rectangle()
                                .foregroundColor(Color(.secondarySystemBackground))
                                .frame(width: 100, height: 100)
                                .overlay(
                                    pokemon.sprite
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 70, height: 70)
                                )
                                .onTapGesture {
                                    self.selectedPokemon = pokemon
                                    self.selectedForm = pokemon.forms.first(where: {$0.isDefault})!
                                }
                                .cornerRadius(23)
                        }
                    }
                }
            }
        }
    }
}
