//
//  TeamMembersDetailView.swift
//  Pokedex
//
//  Created by TempUser on 2/6/21.
//

import SwiftUI
import Kingfisher

struct TeamMembersDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TeamMembersDetailView(team: .constant(testTeams[0]))
    }
}

struct DropOutsideDelegate: DropDelegate {
    @Binding var current: TeamPokemon?
        
    func performDrop(info: DropInfo) -> Bool {
        current = nil
        return true
    }
}

struct DragRelocateDelegate: DropDelegate {
    let item: TeamPokemon
    @Binding var listData: [TeamPokemon]
    @Binding var current: TeamPokemon?
    
    func dropEntered(info: DropInfo) {
        if item != current {
            let from = listData.firstIndex(of: current!)!
            let to = listData.firstIndex(of: item)!
            if listData[to].id != current!.id {
                listData.move(fromOffsets: IndexSet(integer: from),
                    toOffset: to > from ? to + 1 : to)
            }
        }
    }

    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }

    func performDrop(info: DropInfo) -> Bool {
        self.current = nil
        return true
    }
}

struct TeamMembersDetailView: View {
    @EnvironmentObject var pokemonShowdownService: PokemonShowdownService
    @Binding var team: Team

    @State private var editingTeamMembers: Bool = false
    @State private var rotationAmount: Double = 0
    @GestureState private var detectingLongPress: Bool = false
    @State private var completedLongPress: Bool = false
    @State private var longPressIndex: Int = 0
    
    @State private var selectedTeamPokemon: TeamPokemon?
    @State private var showPokemonSelectionView: Bool = false
    @State private var showPokemonSelectionActionSheet: Bool = false
        
    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible(), spacing: 15), GridItem(.flexible(), spacing: 15), GridItem(.flexible(), spacing: 15)], spacing: 15) {
            ForEach(team.pokemon) { pokemon in
                ZStack {
                    TeamMemberDetailView(pokemon: pokemon)
                        .animation(nil)
                        .rotationEffect(Angle.degrees(editingTeamMembers ? 6 : 0))
                        .animation(editingTeamMembers ? Animation.default.repeatForever() : Animation.default)
                        .rotationEffect(Angle.degrees(rotationAmount))
                        .animation(Animation.default)
                        .gesture(
                            TapGesture(count: 1).onEnded() { _ in
                                if editingTeamMembers {
                                    editingTeamMembers = false
                                    rotationAmount = 0
                                } else {
                                    selectedTeamPokemon = pokemon
                                }
                            }
                            .exclusively(before:
                                            LongPressGesture(minimumDuration: 1)
                                            .updating($detectingLongPress, body: { (currentState, gestureState, transaction) in
                                                gestureState = currentState
                                            })
                                            .onEnded() { finished in
                                                completedLongPress = finished
                                                if !editingTeamMembers {
                                                    editingTeamMembers = true
                                                    rotationAmount = -3
                                                    return
                                                }
                            }))
                        .sheet(item: $selectedTeamPokemon) { selectedTeamPokemon in
                            if let index = team.pokemon.firstIndex(of: selectedTeamPokemon) {
                                TeamPokemonDetailView(teamPokemon: $team.pokemon[index]).environmentObject(swiftDexService)
                            }
                        }
                        VStack {
                            HStack {
                                Spacer()
                                if editingTeamMembers {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.system(size: 30))
                                        .foregroundColor(Color(.secondaryLabel))
                                        .zIndex(1)
                                        .offset(x: 10, y: -10)
                                        .highPriorityGesture(TapGesture().onEnded() { _ in
                                            if let index = team.pokemon.firstIndex(of: pokemon) {
                                                team.pokemon.remove(at: index)
                                            }
                                        })
                                } else {
                                    Button(action: {
                                        pokemonShowdownService.exportToClipboard(pokemon)
                                    }, label: {
                                        Image(systemName: "doc.on.doc")
                                            .font(.system(size: 20))
                                            .foregroundColor(Color(.secondaryLabel))
                                            .zIndex(1)
                                            .padding(.top, 4)
                                            .padding(.trailing, 4)
                                    })
                                }
                                
                            }
                            Spacer()
                        }
                    
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            pokemon.item?.image
                                .resizable()
                                .frame(width: 35, height: 35)
                                .padding(.bottom, 2)
                                .padding(.trailing, 2)
                        }
                    }
                }
            }
            
            if team.pokemon.count < 6 && !editingTeamMembers {
                TeamMemberEmptyDetailView()
                    .transition(AnyTransition.move(edge: .trailing).animation(.default))
                    .onTapGesture {
                        showPokemonSelectionActionSheet = true
                    }
                    .actionSheet(isPresented: $showPokemonSelectionActionSheet) {
                        ActionSheet(title: Text("Selected Creation Method"), message: nil, buttons: [
                            ActionSheet.Button.default(Text("From Scratch"), action: {
                                showPokemonSelectionView = true
                            }),
                            ActionSheet.Button.default(Text("Import From Clipboard"), action: {
                                if let newPokemon = pokemonShowdownService.importPokemonFromClipboard() {
                                    team.pokemon.append(newPokemon)
                                }
                            }),
                            ActionSheet.Button.cancel()
                        ])
                    }
                    .sheet(isPresented: $showPokemonSelectionView) {
                        TeamPokemonSelectionView(teamPokemon: $team.pokemon).environmentObject(swiftDexService)
                            .zIndex(1)
                    }
            }
        }
        .animation(.default, value: team.pokemon)
        .animation(.default, value: editingTeamMembers)
    }
}

struct TeamPokemonSelectionView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var swiftDexService: SwiftDexService
    @Binding var teamPokemon: [TeamPokemon]
    
    @State private var searchText: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            TextField("Search Pokemon", text: $searchText)
                .font(.title)
                .modifier(ClearButton(text: $searchText))
                .padding()
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 10) {
                    ForEach(swiftDexService.pokemon(matching: searchText)) { pokemon in
                        TeamPokemonSummaryView(pokemon: pokemon, shiny: false)
                            .onTapGesture {
                                teamPokemon.append(TeamPokemon(pokemon: pokemon))
                                presentationMode.wrappedValue.dismiss()
                            }
                    }
                }
                .padding(.top)
            }
            .padding(.horizontal)
            .background(Color(.secondarySystemBackground))
        }
    }
}

struct TeamMemberEmptyDetailView: View {
    var body: some View {
        Rectangle()
            .foregroundColor(Color(.secondarySystemBackground))
            .overlay(
                Image(systemName: "plus.circle")
                    .foregroundColor(Color(.systemFill))
                    .font(.system(size: 55))
            )
            .aspectRatio(1.0, contentMode: .fill)
        .cornerRadius(10)
    }
}

struct TeamMemberDetailView: View {
    let pokemon: TeamPokemon
    
    private var backgroundColor: Color {
        return pokemon.pokemon.color.opacity(0.25)
    }
    
    var body: some View {
        VStack {
            pokemon.pokemon.sprite
                .resizable()
                .scaledToFit()
                .padding()
        }
        .background(backgroundColor)
        .cornerRadius(10)
    }
}
