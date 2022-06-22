//
//  PokemonAbilitiesView.swift
//  SwiftDex
//
//  Created by Brian Corbin on 4/3/22.
//

import SwiftUI

struct PokemonAbilitiesInfoView: View {
    let slot1Ability: PokemonAbility
    let slot2Ability: PokemonAbility?
    let slot3Ability: PokemonAbility?
    let color: Color
    
    var body: some View {
        VStack {
            PokemonDetailSectionHeader(text: "Abilities")
            VStack {
                HStack {
                    PokemonAbilityInfoView(name: slot1Ability.name, isHidden: slot1Ability.isHidden, color: color)

                    if let slot2Ability = slot2Ability {
                        PokemonAbilityInfoView(name: slot2Ability.name, isHidden: slot2Ability.isHidden, color: color)
                    }
                }

                if let slot3Ability = slot3Ability {
                    PokemonAbilityInfoView(name: slot3Ability.name, isHidden: slot3Ability.isHidden, color: color)
                }
            }
        }
    }
}

struct PokemonAbilityInfoView: View {
    
    let name: String
    let isHidden: Bool
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: isHidden ? "eye.slash" : "eye")
            Text(name)
                .frame(minWidth: 0, maxWidth: .infinity)
                .minimumScaleFactor(0.5)
                .lineLimit(1)
            Image(systemName: "info.circle")
        }
        .padding(.horizontal)
        .padding(.vertical, 9)
        .background(isHidden ? Color(.systemBackground) : color)
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(color, lineWidth: 4))
        .cornerRadius(8)
    }
}

struct PokemonAbilitiesView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonAbilitiesInfoView(slot1Ability: testRealm.object(ofType: Pokemon.self, forPrimaryKey: 1)!.slot1Ability, slot2Ability: testRealm.object(ofType: Pokemon.self, forPrimaryKey: 1)!.slot2Ability, slot3Ability: testRealm.object(ofType: Pokemon.self, forPrimaryKey: 1)!.slot3Ability, color: .grass)
            .previewLayout(.sizeThatFits)
        PokemonAbilityInfoView(name: "Overgrow", isHidden: false, color: .grass)
            .previewLayout(.sizeThatFits)
        PokemonAbilityInfoView(name: "Chlorophyll", isHidden: true, color: .grass)
            .previewLayout(.sizeThatFits)
    }
}
