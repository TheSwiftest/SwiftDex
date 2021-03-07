//
//  PokemonDetailView.swift
//  Pokedex
//
//  Created by BrianCorbin on 1/24/21.
//

import SwiftUI

struct PokemonView: View {
    @EnvironmentObject var swiftDexService: SwiftDexService

    let pokemonDexNumber: PokemonDexNumber
    @State var selectedVersionGroup: VersionGroup
    @State var selectedVersion: Version
    @State var selectedPokemon: Pokemon
    @State var selectedPokemonForm: PokemonForm
    @State var showingContent: Bool
    @State var showVersionSelectionView: Bool = false
    @State private var showMoveDetailView: Bool = false
    @State private var selectedMove: Move?

    init(pokemonDexNumber: PokemonDexNumber, selectedVersionGroup: VersionGroup, showingContent: Bool = false) {
        self.pokemonDexNumber = pokemonDexNumber
        _selectedVersionGroup = State(initialValue: selectedVersionGroup)
        _selectedVersion = State(initialValue: selectedVersionGroup.versions.first!)
        _showingContent = State(initialValue: showingContent)

        _selectedPokemon = State(initialValue: pokemonDexNumber.pokemon!)
        _selectedPokemonForm = State(initialValue: pokemonDexNumber.pokemon!.defaultForm)
    }

    private var color: Color {
        return selectedPokemon.types.first(where: {$0.slot == 1})?.type?.color ?? .fire
    }

    var body: some View {
        GeometryReader { _ in
            ZStack {
                VStack(spacing: 0) {
                    PokemonSummaryView(pokemonDexNumber: pokemonDexNumber, pokemon: selectedPokemon, showingContent: showingContent,
                                       showVersionSelectionView: $showVersionSelectionView, selectedVersion: $selectedVersion)
                        .frame(height: showingContent ? 152 : 112)
                        .sheet(isPresented: $showVersionSelectionView) {
                            VersionGroupSelectionView(generations: swiftDexService.generations, pokemonFormRestriction: selectedPokemonForm,
                                                      selectedVersionGroup: $selectedVersionGroup, selectedVersion: $selectedVersion)
                        }
                    if showingContent {
                        TabView {
                            PokemonBasicInfoView(pokemon: $selectedPokemon, pokemonForm: $selectedPokemonForm, selectedVersionGroup: selectedVersionGroup)
                            .tabItem {
                                Image(systemName: "info.circle")
                                Text("Info")
                            }
                            PokemonMovesView(selectedPokemon: selectedPokemon, selectedLearnMethod: swiftDexService.moveLearnMethodsForSelectedVersionGroup.first!,
                                             selectedVersion: selectedVersion, selectedMove: $selectedMove, showMoveDetailView: $showMoveDetailView)
                                .sheet(item: $selectedMove) { move in
                                    MoveDetailView(move: move, versionGroup: selectedVersionGroup)
                                }
                            .tabItem {
                                Image("tab_icon_moves")
                                Text("Moves")
                            }
                            PokemonBreedingView(pokemon: selectedPokemon)
                            .tabItem {
                                Image("tab_icon_breeding")
                                Text("Breeding")
                            }
                        }
                        .accentColor(color)
                    }

                }
                .zIndex(0)

//                if let selectedMove = selectedMove, showMoveDetailView {
//                    GeometryReader { geo in
//                        BlankView(bgColor: .black)
//                            .opacity(0.5)
//                            .onTapGesture {
//                                showMoveDetailView = false
//                            }
//                        MoveDetailView(move: selectedMove, versionGroup: selectedVersionGroup)
//                            .modifier(ExpandableBottomSheet(containerHeight: geo.size.height, showing: $showMoveDetailView))
//                    }
//                    .transition(.move(edge: .bottom))
//                    .edgesIgnoringSafeArea(.bottom)
//                }
            }
        }
    }
}

struct PokemonDetailSectionHeader: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.title2)
            .bold()
    }
}
