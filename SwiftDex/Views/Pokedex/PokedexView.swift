//
//  PokedexView.swift
//  SwiftDex
//
//  Created by Brian Corbin on 4/4/22.
//

import SwiftUI

struct PokedexView: View {
    let pokemon: [PokemonDexNumber]
    let generations: [Generation]
    let moveDamageClasses: [MoveDamageClass]
    let moves: [Move]
    
    @Binding var selectedVersionGroup: VersionGroup
    @Binding var selectedVersion: Version
    @Binding var selectedPokedex: Pokedex?
    @Binding var selectedMoveDamageClass: MoveDamageClass?
    
    @Binding var searchText: String
    
    let speciesVariationsForPokemon: (_ pokemon: Pokemon) -> [Pokemon]
    let alternateFormsForPokemon: (_ pokemon: Pokemon) -> [PokemonForm]
    let movesForPokemon: (_ pokemon: Pokemon) -> [PokemonMove]
    
    @State private var selectedDexCategory: DexCategory = .pokémon
    
    @State private var showDexCategorySelectionView = false
    @State private var dexCategorySelectedViewSourceFrame = CGRect.zero
    
    @State private var pokemonToShow: PokemonDexNumber?
    @State private var moveToShow: Move?

    @State private var pokedexSelectedViewSourceFrame = CGRect.zero
    @State private var showPokedexSelectionView = false
    
    @State private var moveDamageClassSelectedViewSourceFrame = CGRect.zero
    @State private var showMoveDamageClassSelectionView = false
    
    var body: some View {
        ZStack {
            GeometryReader { fullView in
                VStack(spacing: 0) {
                    VStack {
                        PokedexSearchView(selectedDexCategory: $selectedDexCategory, showDexCategorySelectionView: $showDexCategorySelectionView, dexCategorySelectedViewSourceFrame: $dexCategorySelectedViewSourceFrame, searchText: $searchText)
                        
                        PokedexFilterView(generations: generations, moveDamageClasses: moveDamageClasses, selectedVersionGroup: $selectedVersionGroup, selectedVersion: $selectedVersion, selectedPokedex: selectedPokedex, selectedMoveDamageClass: selectedMoveDamageClass, selectedDexCategory: selectedDexCategory, pokedexSelectedViewSourceFrame: $pokedexSelectedViewSourceFrame, showPokedexSelectionView: $showPokedexSelectionView, moveDamageClassSelectedViewSourceFrame: $moveDamageClassSelectedViewSourceFrame, showMoveDamageClassSelectionView: $showMoveDamageClassSelectionView)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .background(Color(.clear))
                    
                    ScrollView {
                        if selectedDexCategory == .pokémon {
                            PokemonListView(pokemonDexNumbers: pokemon, pokemonToShow: $pokemonToShow)
                                .sheet(item: $pokemonToShow) { pokemonDexNumber in
                                    PokemonInfoView(pokemon: pokemonDexNumber.pokemon!, pokedexNumber: pokemonDexNumber.pokedexNumber, version: selectedVersion, speciesVariations: speciesVariationsForPokemon(pokemonDexNumber.pokemon!), alternateForms: alternateFormsForPokemon(pokemonDexNumber.pokemon!), moveLearnMethods: Array(selectedVersionGroup.pokemonMoveMethods.filter({$0.pokemonMoveMethod!.id <= 4})).map({$0.pokemonMoveMethod!}), pokemonMoves: movesForPokemon(pokemonDexNumber.pokemon!))
                                }
                        }
                        
                        if selectedDexCategory == .moves {
                            LazyVStack(spacing: 2) {
                                ForEach(moves) { move in
                                    MoveSummaryInfoView(move: move, subtitle: nil)
                                        .onTapGesture {
                                            moveToShow = move
                                        }
                                }
                            }
                            .sheet(item: $moveToShow) { move in
                                MoveDetailView(move: move, versionGroup: selectedVersionGroup)
                            }
                        }
                    }
                    .background(Color(.secondarySystemBackground))
                }
            }
            
            if showDexCategorySelectionView || showPokedexSelectionView || showMoveDamageClassSelectionView {
                BlankView(bgColor: .black)
                    .opacity(0.5)
                    .onTapGesture {
                        showDexCategorySelectionView = false
                        showPokedexSelectionView = false
                        showMoveDamageClassSelectionView = false
                    }
            }
            
            GeometryReader { _ in
                DexCategorySelectionView(selectedDexCategory: $selectedDexCategory, showView: $showDexCategorySelectionView, sourceFrame: $dexCategorySelectedViewSourceFrame, searchText: $searchText)
                PokedexSelectionView(pokedexes: selectedVersionGroup.pokedexes.map({$0.pokedex!}), sourceFrame: $pokedexSelectedViewSourceFrame, showView: $showPokedexSelectionView, selectedPokedex: $selectedPokedex)
                MoveDamageClassSelectionView(moveDamageClasses: moveDamageClasses, sourceFrame: $moveDamageClassSelectedViewSourceFrame, showView: $showMoveDamageClassSelectionView, selectedMoveDamageClass: $selectedMoveDamageClass)
            }
            .edgesIgnoringSafeArea(.top)
        }
    }
}

//struct PokedexView_Previews: PreviewProvider {
//    static var previews: some View {
//        PokedexView(pokemon: Array(testRealm.object(ofType: Pokedex.self, forPrimaryKey: 1)!.pokemonDexNumbers), generations: Array(testRealm.objects(Generation.self)), moveDamageClasses: Array(testRealm.objects(MoveDamageClass.self)), moves: Array(testRealm.object(ofType: Generation.self, forPrimaryKey: 1)!.moves), selectedVersionGroup: .constant(testRealm.object(ofType: VersionGroup.self, forPrimaryKey: 1)!), selectedVersion: .constant(testRealm.object(ofType: Version.self, forPrimaryKey: 1)!), selectedPokedex: .constant(nil), selectedMoveDamageClass: .constant(nil), searchText: .constant("")) { _ in
//            return []
//        } alternateFormsForPokemon: { _ in
//            return []
//        } movesForPokemon: { _ in
//            return []
//        }
//
//    }
//}
