//
//  PokedexView.swift
//  SwiftDex
//
//  Created by Brian Corbin on 4/4/22.
//

import SwiftUI

struct PokedexView: View {
    let pokemon: [PokemonSummary]
    let pokemonInfo: (_ pokemonId: Int) -> PokemonInfo
    let generations: [GenerationInfo]
    let moveDamageClasses: [MoveDamageClassInfo]
    let moves: [MoveInfo]
    
    @Binding var selectedVersionGroup: VersionGroupInfo
    @Binding var selectedVersion: VersionInfo
    @Binding var selectedPokedex: PokedexInfo
    @State private var selectedMoveDamageClass: MoveDamageClassInfo? = nil
    
    @Binding var searchText: String
    @State private var selectedDexCategory: DexCategory = .pokémon
    
    @State private var showDexCategorySelectionView = false
    @State private var dexCategorySelectedViewSourceFrame = CGRect.zero
    
    @State private var pokemonToShow: PokemonSummary?
    @State private var moveToShow: MoveInfo?

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
                            PokemonListView(pokemon: pokemon, pokemonToShow: $pokemonToShow)
                                .sheet(item: $pokemonToShow) { pokemonSummary in
                                    PokemonInfoView(pokemonInfo: pokemonInfo(pokemonSummary.id), selectedPokemon: $pokemonToShow)
                                }
                        }
                        
                        if selectedDexCategory == .moves {
                            LazyVStack(spacing: 2) {
                                ForEach(moves) { move in
                                    MoveSummaryInfoView(moveLearnInfo: nil, moveInfo: move)
                                        .onTapGesture {
                                            moveToShow = move
                                        }
                                }
                            }
                            .sheet(item: $moveToShow) { moveInfo in
                                MoveDetailView(move: moveInfo)
                            }
                        }
                    }
                    
                    Spacer()
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
                PokedexSelectionView(pokedexes: selectedVersionGroup.pokedexes, sourceFrame: $pokedexSelectedViewSourceFrame, showView: $showPokedexSelectionView, selectedPokedex: $selectedPokedex)
                MoveDamageClassSelectionView(moveDamageClasses: moveDamageClasses, sourceFrame: $moveDamageClassSelectedViewSourceFrame, showView: $showMoveDamageClassSelectionView, selectedMoveDamageClass: $selectedMoveDamageClass)
            }
            .edgesIgnoringSafeArea(.top)
        }
    }
}

struct PokedexView_Previews: PreviewProvider {
    static var previews: some View {
        PokedexView(pokemon: testPokemonSummaries, pokemonInfo: testGetPokemonInfo(forId:), generations: testGenerations, moveDamageClasses: testMDCs, moves: testMoves, selectedVersionGroup: .constant(redBlueVG), selectedVersion: .constant(redVersion), selectedPokedex: .constant(kantoDex), searchText: .constant(""))
    }
}
