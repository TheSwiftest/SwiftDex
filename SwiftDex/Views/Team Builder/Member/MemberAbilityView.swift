//
//  MemberAbilityView.swift
//  SwiftDex
//
//  Created by Brian Corbin on 6/22/22.
//

import SwiftUI

struct MemberAbilitiesView: View {
    let slot1Ability: PokemonAbility
    let slot2Ability: PokemonAbility?
    let slot3Ability: PokemonAbility?
    let color: Color
    @Binding var ability: Ability?

    var body: some View {
        VStack {
            PokemonDetailSectionHeader(text: "Ability")

            HStack {
                MemberAbilityView(pokemonAbility: slot1Ability, color: color, selectedAbility: $ability)

                if let slot2Ability = slot2Ability {
                    MemberAbilityView(pokemonAbility: slot2Ability, color: color, selectedAbility: $ability)
                }
            }

            if let slot3Ability = slot3Ability {
                MemberAbilityView(pokemonAbility: slot3Ability, color: color, selectedAbility: $ability)
            }
        }
    }
}

struct MemberAbilityView: View {
    let pokemonAbility: PokemonAbility
    let color: Color
    @Binding var selectedAbility: Ability?

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .frame(height: 34)
                .foregroundColor(pokemonAbility.ability! == selectedAbility ? color : Color(.systemBackground))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(color, lineWidth: 2)
                )

            Text(pokemonAbility.name)
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

struct MemberAbilityView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MemberAbilitiesView(slot1Ability: SwiftDexService.pokemon(withId: 1)!.slot1Ability, slot2Ability: SwiftDexService.pokemon(withId: 1)!.slot2Ability, slot3Ability: SwiftDexService.pokemon(withId: 1)!.slot3Ability, color: .grass, ability: .constant(SwiftDexService.pokemon(withId: 1)!.slot3Ability?.ability))
            MemberAbilityView(pokemonAbility: SwiftDexService.pokemon(withId: 1)!.slot1Ability, color: .grass, selectedAbility: .constant(nil))
            MemberAbilityView(pokemonAbility: SwiftDexService.pokemon(withId: 1)!.slot1Ability, color: .grass, selectedAbility: .constant(SwiftDexService.pokemon(withId: 1)!.slot1Ability.ability))
        }
        .previewLayout(.sizeThatFits)
    }
}
