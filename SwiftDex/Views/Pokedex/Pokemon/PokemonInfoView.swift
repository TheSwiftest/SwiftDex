//
//  PokemonInfoView.swift
//  SwiftDex
//
//  Created by Brian Corbin on 4/4/22.
//

import SwiftUI

struct PokemonInfoView: View {
    @State var pokemon: Pokemon
    let pokedexNumber: Int
    let version: Version
    
    let speciesVariations: (_ pokemon: Pokemon) -> [Pokemon]
    let battleOnlyForms: (_ pokemon: Pokemon) -> [PokemonForm]
    let alternateForms: (_ pokemon: Pokemon) -> [PokemonForm]
    let pokemonMoves: (_ pokemon: Pokemon) -> [PokemonMove]

    @State private var showVersionSelectionView: Bool = false
    
    var body: some View {
        VStack(spacing: 5) {
            PokemonSummaryView(pokemon: pokemon, pokedexNumber: pokedexNumber, showVersionView: true, showVersionSelectionView: $showVersionSelectionView)
            TabView {
                PokemonBasicInfoView(pokemon: $pokemon, speciesVariations: speciesVariations(pokemon), battleOnlyForms: battleOnlyForms(pokemon), alternateForms: alternateForms(pokemon))
                    .tabItem {
                        Image(systemName: "info.circle")
                        Text("Info")
                    }
                if pokemonMoves(pokemon).count > 0 {
                    MovesInfoView(pokemonMoves: pokemonMoves(pokemon))
                        .tabItem {
                            Image("icon/tab/moves")
                            Text("Moves")
                        }
                }
                PokemonBreedingInfoView(breedingInfo: PokemonBreedingInfo(pokemon: pokemon), color: pokemon.color)
                    .tabItem {
                        Image("icon/tab/breeding")
                        Text("Breeding")
                    }
            }
            .accentColor(pokemon.color)
        }
    }
}

//struct PokemonInfoView_Previews: PreviewProvider {
//    static var previews: some View {
//        PokemonInfoView(pokemon: testRealm.object(ofType: Pokemon.self, forPrimaryKey: 1)!, pokedexNumber: 1, version: testRealm.object(ofType: Version.self, forPrimaryKey: 1)!, speciesVariations: [], alternateForms: [], moveLearnMethods: Array(testRealm.objects(PokemonMoveMethod.self).filter({$0.id <= 4})), pokemonMoves: Array(testRealm.object(ofType: Pokemon.self, forPrimaryKey: 1)!.moves.filter({$0.versionGroup!.id == 4})))
//    }
//}
