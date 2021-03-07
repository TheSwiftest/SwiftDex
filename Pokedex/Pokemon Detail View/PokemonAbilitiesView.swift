//
//  PokemonAbilitiesView.swift
//  Pokedex
//
//  Created by TempUser on 1/25/21.
//

import SwiftUI

struct PokemonAbilitiesView: View {
    let pokemon: Pokemon
    
    private var color: Color {
        return pokemon.types.first(where: {$0.slot == 1})?.type?.color ?? .fire
    }
    
    var body: some View {
        VStack {
            PokemonDetailSectionHeader(text: "Abilities")
            VStack {
                HStack {
                    if let slot1Abilitiy = pokemon.abilities.first(where: {$0.slot == 1}) {
                        PokemonAbilityView(pokemonAbility: slot1Abilitiy, color: color)
                    }
                    
                    if let slot2Ability = pokemon.abilities.first(where: {$0.slot == 2}) {
                        PokemonAbilityView(pokemonAbility: slot2Ability, color: color)
                    }
                }
                
                if let slot3Ability = pokemon.abilities.first(where: {$0.slot == 3}) {
                    PokemonAbilityView(pokemonAbility: slot3Ability, color: color)
                }
            }
        }
    }
}

struct PokemonAbilityView: View {
    
    let pokemonAbility: PokemonAbility
    let color: Color
    
    private var abilityName: String {
        return pokemonAbility.ability!.names.first(where: {$0.localLanguageId == 9})?.name ?? pokemonAbility.ability!.identifier
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .frame(height: 34)
                .foregroundColor(pokemonAbility.isHidden ? Color(.systemBackground) : color)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(color, lineWidth: 2)
                )
            HStack {
                Image(systemName: pokemonAbility.isHidden ? "eye.slash" : "eye")
                Text(abilityName)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                Image(systemName: "info.circle")
            }
            .padding(.horizontal)
        }
    }
}
