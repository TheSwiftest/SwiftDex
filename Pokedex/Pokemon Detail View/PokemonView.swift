//
//  PokemonDetailView.swift
//  Pokedex
//
//  Created by TempUser on 1/24/21.
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
        
        let region = pokemonDexNumber.pokedex!.region
        let pokemonRegionalVersion = pokemonDexNumber.species!.pokemonForm(for: region)
        
        _selectedPokemon = State(initialValue: pokemonRegionalVersion)
        _selectedPokemonForm = State(initialValue: pokemonRegionalVersion.defaultForm)
    }
    
    private var color: Color {
        return selectedPokemon.types.first(where: {$0.slot == 1})?.type?.color ?? .fire
    }
    
    var body: some View {
        GeometryReader { fullView in
            ZStack {
                VStack(spacing: 0) {
                    PokemonSummaryView(pokemonDexNumber: pokemonDexNumber, selectedPokemon: $selectedPokemon, selectedForm: $selectedPokemonForm, showingContent: $showingContent, showVersionSelectionView: $showVersionSelectionView, selectedVersion: $selectedVersion)
                        .frame(height: showingContent ? 152 : 112)
                        .sheet(isPresented: $showVersionSelectionView) {
                            VersionGroupSelectionView(generations: swiftDexService.generations, pokemonFormRestriction: selectedPokemonForm, selectedVersionGroup: $selectedVersionGroup, selectedVersion: $selectedVersion)
                        }
                    if showingContent {
                        TabView {
                            PokemonBasicInfoView(species: pokemonDexNumber.species!, pokemon: $selectedPokemon, pokemonForm: $selectedPokemonForm, selectedVersionGroup: $selectedVersionGroup)
                            .tabItem {
                                Image(systemName: "info.circle")
                                Text("Info")
                            }
                            PokemonMovesView(selectedPokemon: $selectedPokemon, selectedLearnMethod: swiftDexService.moveLearnMethodsForSelectedVersionGroup.first!, selectedVersion: $selectedVersion, selectedMove: $selectedMove, showMoveDetailView: $showMoveDetailView)
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
                
                if let selectedMove = selectedMove, showMoveDetailView {
                    BlankView(bgColor: .black)
                        .opacity(0.5)
                        .onTapGesture {
                            showMoveDetailView = false
                        }
                        .zIndex(1)
                    MoveDetailView(move: selectedMove, versionGroup: selectedVersionGroup)
                        .modifier(ExpandableBottomSheet(isShow: $showMoveDetailView))
                        .transition(.move(edge: .bottom))
                        .zIndex(2)
                }
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
