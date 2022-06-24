//
//  PokemonBasicInfoView.swift
//  SwiftDex
//
//  Created by Brian Corbin on 4/3/22.
//

import SwiftUI

struct PokemonBasicInfoView: View {
    @Binding var pokemon: Pokemon
    let speciesVariations: [Pokemon]
    let battleOnlyForms: [PokemonForm]
    let alternateForms: [PokemonForm]

    var body: some View {
        ScrollView {
            VStack {
                Group {
                    SpeciesInfoView(id: pokemon.id, height: pokemon.height, weight: pokemon.weight, bodyShape: pokemon.bodyShape, genus: pokemon.genus, color: pokemon.color)
                    PokemonAbilitiesInfoView(slot1Ability: pokemon.slot1Ability, slot2Ability: pokemon.slot2Ability, slot3Ability: pokemon.slot3Ability, color: pokemon.color)
                    PokemonStatsInfoView(stats: Array(pokemon.stats), color: pokemon.color)
                    
                    if !(speciesVariations.count == 1 && speciesVariations.first! == pokemon){
                        SpeciesVariationsView(variations: speciesVariations, pokemonSelected: $pokemon)
                    }
                    
                    if !battleOnlyForms.isEmpty {
                        BattleOnlyFormsView(forms: battleOnlyForms, pokemon: $pokemon)
                    }
                    
                    if alternateForms.count > 1 {
                        AlternateFormsView(forms: alternateForms)
                    }
                }
                .padding()
            }
        }
    }
}

struct PokemonBasicInfoView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonBasicInfoView(pokemon: .constant(SwiftDexService.pokemon(withId: 45)!), speciesVariations: SwiftDexService.speciesVariations(for: SwiftDexService.pokemon(withId: 45)!, in: SwiftDexService.versionGroup(withId: 20)!), battleOnlyForms: SwiftDexService.battleOnlyForms(for: SwiftDexService.pokemon(withId: 45)!, in: SwiftDexService.versionGroup(withId: 20)!), alternateForms: SwiftDexService.alternateForms(for: SwiftDexService.pokemon(withId: 45)!, in: SwiftDexService.versionGroup(withId: 20)!))
    }
}
