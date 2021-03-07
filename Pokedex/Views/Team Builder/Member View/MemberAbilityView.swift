//
//  TeamPokemonAbilityVIew.swift
//  Pokedex
//
//  Created by BrianCorbin on 2/8/21.
//

import SwiftUI

struct TeamPokemonAbilitiesView: View {
    let pokemonAbilities: [PokemonAbility]
    let color: Color
    @Binding var ability: Ability?

    var body: some View {
        VStack {
            PokemonDetailSectionHeader(text: "Ability")

            HStack {
                if let slot1Abilitiy = pokemonAbilities.first(where: {$0.slot == 1}) {
                    TeamPokemonAbilityView(pokemonAbility: slot1Abilitiy, color: color, selectedAbility: $ability)
                }

                if let slot2Ability = pokemonAbilities.first(where: {$0.slot == 2}) {
                    TeamPokemonAbilityView(pokemonAbility: slot2Ability, color: color, selectedAbility: $ability)
                }
            }

            if let slot3Ability = pokemonAbilities.first(where: {$0.slot == 3}) {
                TeamPokemonAbilityView(pokemonAbility: slot3Ability, color: color, selectedAbility: $ability)
            }
        }
    }
}

struct TeamPokemonAbilityView: View {

    let pokemonAbility: PokemonAbility
    let color: Color
    @Binding var selectedAbility: Ability?

    private var abilityName: String {
        return pokemonAbility.ability!.names.first(where: {$0.localLanguageId == 9})?.name ?? pokemonAbility.ability!.identifier
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .frame(height: 34)
                .foregroundColor(pokemonAbility.ability! == selectedAbility ? color : Color(.systemBackground))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(color, lineWidth: 2)
                )

            Text(abilityName)
                .frame(minWidth: 0, maxWidth: .infinity)
                .minimumScaleFactor(0.5)
                .lineLimit(1)

            HStack {
                Image(systemName: pokemonAbility.isHidden ? "eye.slash" : "eye")
                Spacer()
            }
            .padding(.horizontal)
        }
        .onTapGesture {
            selectedAbility = pokemonAbility.ability!
        }
    }
}
