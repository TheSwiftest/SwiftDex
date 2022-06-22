//
//  MemberDetailView.swift
//  SwiftDex
//
//  Created by Brian Corbin on 6/22/22.
//

import SwiftUI

struct MemberDetailView: View {
    @Binding private var teamPokemonOriginal: TeamPokemon
    @State private var teamPokemon: TeamPokemon

    init(teamPokemon: Binding<TeamPokemon>) {
        _teamPokemonOriginal = teamPokemon
        _teamPokemon = State(initialValue: teamPokemon.wrappedValue)
    }

    var body: some View {
        VStack(spacing: 0) {
            MemberSummaryView(pokemon: teamPokemon.pokemon, shiny: teamPokemon.shiny)
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    MemberNicknameGenderView(genders: [SwiftDexService.male, SwiftDexService.female],
                                                     nickname: $teamPokemon.nickname, gender: $teamPokemon.gender, color: teamPokemon.pokemon.color)
                    MemberAbilitiesView(slot1Ability: teamPokemon.pokemon.slot1Ability, slot2Ability: teamPokemon.pokemon.slot2Ability, slot3Ability: teamPokemon.pokemon.slot3Ability, color: teamPokemon.pokemon.color, ability: $teamPokemon.ability)
                    MemberMoveSetView(pokemon: teamPokemon.pokemon, firstMove: $teamPokemon.firstMove, secondMove: $teamPokemon.secondMove,
                                           thirdMove: $teamPokemon.thirdMove, fourthMove: $teamPokemon.fourthMove)
                    MemberLevelHappyShinyView(level: $teamPokemon.level, happiness: $teamPokemon.happiness, color: teamPokemon.pokemon.color, shiny: $teamPokemon.shiny)
                    MemberNatureAndItemView(availableNatures: SwiftDexService.natures, availableItems: SwiftDexService.items, nature: $teamPokemon.nature, item: $teamPokemon.item)
                    MemberStatsView(pokemonStats: teamPokemon.pokemon.stats.compactMap({ $0 }), nature: teamPokemon.nature, evs: teamPokemon.evs, ivs: teamPokemon.ivs, level: teamPokemon.level)
                    MemberEVsView(evs: $teamPokemon.evs, color: teamPokemon.pokemon.color)
                    MemberIVsView(ivs: $teamPokemon.ivs, color: teamPokemon.pokemon.color)
                }
                .padding()
            }
        }
        .onDisappear {
            _teamPokemonOriginal.wrappedValue = _teamPokemon.wrappedValue
        }
    }
}

struct MemberDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MemberDetailView(teamPokemon: .constant(TeamPokemon(pokemon: SwiftDexService.pokemon(withId: 1)!)))
    }
}
