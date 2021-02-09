//
//  TeamPokemonDetailView.swift
//  Pokedex
//
//  Created by TempUser on 2/5/21.
//

import SwiftUI
import Kingfisher

struct TeamPokemonDetailView: View {
    @EnvironmentObject var swiftDexService: SwiftDexService
    
    @Binding private var teamPokemonOriginal: TeamPokemon
    @State private var teamPokemon: TeamPokemon
    
    init(teamPokemon: Binding<TeamPokemon>) {
        _teamPokemonOriginal = teamPokemon
        _teamPokemon = State(initialValue: teamPokemon.wrappedValue)
    }
    
    private var items: [Item] {
        return swiftDexService.items.compactMap({$0})
    }
    
    private var natures: [Nature] {
        return swiftDexService.natures.compactMap({$0})
    }
    
    var body: some View {
        VStack(spacing: 0) {
            TeamPokemonSummaryView(pokemon: teamPokemon.pokemon, shiny: teamPokemon.shiny)
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    TeamPokemonNicknameAndGenderView(genders: [swiftDexService.male, swiftDexService.female], nickname: $teamPokemon.nickname, gender: $teamPokemon.gender, color: teamPokemon.pokemon.color)
                    TeamPokemonAbilitiesView(pokemonAbilities: teamPokemon.pokemon.abilities.compactMap({$0}), color: teamPokemon.pokemon.color, ability: $teamPokemon.ability)
                    TeamPokemonMoveSetView(pokemon: teamPokemon.pokemon, firstMove: $teamPokemon.firstMove, secondMove: $teamPokemon.secondMove, thirdMove: $teamPokemon.thirdMove, fourthMove: $teamPokemon.fourthMove)
                    TeamPokemonLevelAndHappinessView(level: $teamPokemon.level, happiness: $teamPokemon.happiness, color: teamPokemon.pokemon.color, shiny: $teamPokemon.shiny)
                    TeamPokemonNatureAndItemView(availableNatures: natures, availableItems: items, nature: $teamPokemon.nature, item: $teamPokemon.item)
                    TeamPokemonStatsView(pokemonStats: teamPokemon.pokemon.stats.compactMap({$0}), nature: teamPokemon.nature, evs: teamPokemon.evs, ivs: teamPokemon.ivs, level: teamPokemon.level)
                    TeamPokemonEVsView(evs: $teamPokemon.evs, color: teamPokemon.pokemon.color)
                    TeamPokemonIVsView(ivs: $teamPokemon.ivs, color: teamPokemon.pokemon.color)
                }
                .padding()
            }
        }
        .onDisappear() {
            _teamPokemonOriginal.wrappedValue = _teamPokemon.wrappedValue
        }
    }
}

struct TeamPokemonDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TeamPokemonDetailView(teamPokemon: .constant(TeamPokemon(pokemon: SwiftDexService().pokemon(withId: 1)!))).environmentObject(SwiftDexService())
            .edgesIgnoringSafeArea(.bottom)
    }
}
