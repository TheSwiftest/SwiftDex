//
//  PokemonBasicInfoView.swift
//  SwiftDex
//
//  Created by Brian Corbin on 4/3/22.
//

import SwiftUI

struct PokemonBasicInfoView: View {
    let pokemon: Pokemon
    let speciesVariations: [Pokemon]
    let alternateForms: [PokemonForm]

    var body: some View {
        ScrollView {
            VStack {
                Group {
                    SpeciesInfoView(id: pokemon.id, height: pokemon.height, weight: pokemon.weight, bodyShape: pokemon.bodyShape, genus: pokemon.genus, color: pokemon.color)
                    PokemonAbilitiesInfoView(slot1Ability: pokemon.slot1Ability, slot2Ability: pokemon.slot2Ability, slot3Ability: pokemon.slot3Ability, color: pokemon.color)
                    PokemonStatsInfoView(stats: Array(pokemon.stats), color: pokemon.color)
                    SpeciesVariationsView(variations: speciesVariations)
                    AlternateFormsView(forms: alternateForms)
                }
                .padding()
            }
        }
    }
}

struct PokemonBasicInfoView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonBasicInfoView(pokemon: testRealm.object(ofType: Pokemon.self, forPrimaryKey: 1)!, speciesVariations: [], alternateForms: [])
    }
}
