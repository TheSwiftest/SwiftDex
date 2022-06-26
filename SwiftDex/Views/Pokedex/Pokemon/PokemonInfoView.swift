//
//  PokemonInfoView.swift
//  SwiftDex
//
//  Created by Brian Corbin on 4/4/22.
//

import SwiftUI

class PokemonInfoViewModel: ObservableObject {
    @Published var pokemon: Pokemon
    let pokedexNumber: Int
    let pokedex: Pokedex
    let versionGroup: VersionGroup
    
    var speciesVariations: [Pokemon] {
        return SwiftDexService.speciesVariations(for: pokemon, in: versionGroup)
    }
    
    var battleOnlyForms: [PokemonForm] {
        return SwiftDexService.battleOnlyForms(for: pokemon, in: versionGroup)
    }
    
    var alternateForms: [PokemonForm] {
        return SwiftDexService.alternateForms(for: pokemon, in: versionGroup)
    }
    
    var pokemonMoves: [PokemonMove] {
        return SwiftDexService.moves(for: pokemon, in: versionGroup)
    }
    
    var moveLearnMethods: [PokemonMoveMethod] {
        return Array(Set(pokemonMoves.map({$0.pokemonMoveMethod!}))).sorted(by: {$0.id < $1.id})
    }
    
    init(pokemonDexNumber: PokemonDexNumber, versionGroup: VersionGroup) {
        self.pokemon = pokemonDexNumber.pokemon!
        self.pokedex = pokemonDexNumber.pokedex!
        self.versionGroup = versionGroup
        self.pokedexNumber = pokemonDexNumber.pokedexNumber
    }
}

struct PokemonInfoView: View {
    @ObservedObject private var viewModel: PokemonInfoViewModel
    @State private var showVersionSelectionView: Bool = false
    
    init(pokemonDexNumber: PokemonDexNumber, versionGroup: VersionGroup) {
        self.viewModel = PokemonInfoViewModel(pokemonDexNumber: pokemonDexNumber, versionGroup: versionGroup)
    }
    
    var body: some View {
        VStack(spacing: 5) {
            PokemonSummaryView(pokemon: viewModel.pokemon, pokedexNumber: viewModel.pokedexNumber, showVersionView: true, showVersionSelectionView: $showVersionSelectionView)
            TabView {
                PokemonBasicInfoView(pokemon: $viewModel.pokemon, speciesVariations: viewModel.speciesVariations, battleOnlyForms: viewModel.battleOnlyForms, alternateForms: viewModel.alternateForms)
                    .tabItem {
                        Image(systemName: "info.circle")
                        Text("Info")
                    }
                if viewModel.pokemonMoves.count > 0 {
                    MovesInfoView(pokemonMoves: viewModel.pokemonMoves, moveLearnMethods: viewModel.moveLearnMethods, selectedLearnMethod: viewModel.moveLearnMethods.first!)
                        .tabItem {
                            Image("icon/tab/moves")
                            Text("Moves")
                        }
                }
                PokemonBreedingInfoView(breedingInfo: PokemonBreedingInfo(pokemon: viewModel.pokemon), color: viewModel.pokemon.color)
                    .tabItem {
                        Image("icon/tab/breeding")
                        Text("Breeding")
                    }
            }
            .accentColor(viewModel.pokemon.color)
        }
    }
}

struct PokemonInfoView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonInfoView(pokemonDexNumber: SwiftDexService.pokemon(withId: 26)!.dexNumbers.last!, versionGroup: SwiftDexService.versionGroup(withId: 20)!)
    }
}
