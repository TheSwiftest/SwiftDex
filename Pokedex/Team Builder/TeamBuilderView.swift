//
//  TeamBuilderView.swift
//  Pokedex
//
//  Created by TempUser on 2/3/21.
//

import SwiftUI
import Kingfisher

struct Team: Identifiable {
    let id = UUID()
    var name: String
    var pokemon: [TeamPokemon]
    
    var hpAvg: Int {
        return pokemon.map({$0.pokemon.baseHP}).reduce(0, +) / pokemon.count
    }
    var atkAvg: Int {
        return pokemon.map({$0.pokemon.baseATK}).reduce(0, +) / pokemon.count
    }
    var defAvg: Int {
        return pokemon.map({$0.pokemon.baseDEF}).reduce(0, +) / pokemon.count
    }
    var satkAvg: Int {
        return pokemon.map({$0.pokemon.baseSATK}).reduce(0, +) / pokemon.count
    }
    var sdefAvg: Int {
        return pokemon.map({$0.pokemon.baseSDEF}).reduce(0, +) / pokemon.count
    }
    var speAvg: Int {
        return pokemon.map({$0.pokemon.baseSPE}).reduce(0, +) / pokemon.count
    }
    
    func isValid(for searchText: String) -> Bool {
        if searchText.isEmpty { return true }
        return name.localizedCaseInsensitiveContains(searchText) || hasValidPokemon(for: searchText)
    }
    
    private func hasValidPokemon(for searchText: String) -> Bool {
        return pokemon.map({$0.pokemon.name.localizedCaseInsensitiveContains(searchText)}).contains(true)
    }
}

struct TeamPokemon: Identifiable, Equatable {
    let id = UUID()
    
    let pokemon: Pokemon
    
    var nickname: String = ""
    var gender: Gender? = nil
    var ability: Ability? = nil
    var firstMove: Move? = nil
    var secondMove: Move? = nil
    var thirdMove: Move? = nil
    var fourthMove: Move? = nil
    var level: Int = 50
    var shiny: Bool = false
    var item: Item? = nil
    var evs: [Int] = [0,0,0,0,0,0]
    var nature: Nature? = nil
    var ivs: [Int] = [31,31,31,31,31,31]
    
    var availableMoves: [Move] {
        return pokemon.moves.filter("versionGroup.id == 18").distinct(by: ["move.id"]).sorted(byKeyPath: "move.identifier").compactMap({$0.move})
    }
}

struct TeamBuilderView: View {
    @EnvironmentObject var swiftDexService: SwiftDexService
    
    @State private var searchText: String = ""
    @State private var selectedTeam: Team?
    @State private var teams: [Team] = testTeams
    @State private var selectedTeamIndex: Int = 0
    @State private var showTeamDetailView: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            TeamBuilderHeaderView(searchText: $searchText).environmentObject(swiftDexService)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 15) {
                    ForEach(teams.indices) { index in
                        if teams[index].isValid(for: searchText) {
                            TeamSummaryView(team: teams[index])
                                .onTapGesture {
                                    showTeamDetailView = true
                                    selectedTeamIndex = index
                                }
                                .fullScreenCover(isPresented: $showTeamDetailView) {
                                    TeamDetailView(team: $teams[selectedTeamIndex])
                                }
                        }
                    }
                }
                .padding(.vertical)
            }
            .padding(.horizontal)
            .background(Color(.secondarySystemBackground))
        }
    }
}

struct TeamDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @Binding private var teamOriginal: Team
    @State private var team: Team
    
    init(team: Binding<Team>) {
        _teamOriginal = team
        _team = State(initialValue: team.wrappedValue)
    }
    
    var body: some View {
        VStack {
            HStack {
                Button("Discard") {
                    presentationMode.wrappedValue.dismiss()
                }
                Spacer()
                Button("Save") {
                    teamOriginal.name = team.name
                    teamOriginal.pokemon = team.pokemon
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .padding(.horizontal)
            ScrollView {
                VStack(spacing: 20) {
                    VStack(spacing: 2) {
                        TextField("Team Name", text: $team.name)
                            .font(.title)
                            .disableAutocorrection(true)
                        Rectangle()
                            .frame(height: 2)
                            .foregroundColor(Color(.secondarySystemFill))
                    }
                    
                    TeamMembersDetailView(team: $team)
                    
                    TeamStatAvgView(team: team)
                    
                    Spacer()
                }
                .padding()
            }
        }
    }
}

struct TeamStatAvgView: View {
    @State var team: Team
    
    var body: some View {
        VStack {
            PokemonDetailSectionHeader(text: "Average Base Stats")
            PokemonStatView(name: "HP", color: Color(.systemGray2), baseStat: team.hpAvg, max: 300)
            PokemonStatView(name: "ATK", color: Color(.systemGray2), baseStat: team.atkAvg, max: 300)
            PokemonStatView(name: "DEF", color: Color(.systemGray2), baseStat: team.defAvg, max: 300)
            PokemonStatView(name: "SATK", color: Color(.systemGray2), baseStat: team.satkAvg, max: 300)
            PokemonStatView(name: "SDEF", color: Color(.systemGray2), baseStat: team.sdefAvg, max: 300)
            PokemonStatView(name: "SPE", color: Color(.systemGray2), baseStat: team.speAvg, max: 300)
        }
    }
}

struct TeamMemberEmptyDetailView: View {
    var body: some View {
        VStack {
            KFImage(nil)
                .resizable()
                .scaledToFit()
                .padding()
        }
        .background(Color(.secondarySystemBackground))
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
            KFImage(URL(string: pokemon.pokemon.spriteImageLink))
                .resizable()
                .scaledToFit()
                .padding()
        }
        .background(backgroundColor)
        .cornerRadius(10)
    }
}

struct TeamBuilderHeaderView: View {
    
    @EnvironmentObject var swiftDexService: SwiftDexService
    
    @Binding var searchText: String
    
    @State private var showVersionSelectionSheet = false
    
    var body: some View {
        VStack {
            TextField("Team Search", text: $searchText)
                .font(.title)
                .modifier(ClearButton(text: $searchText))
                .frame(maxWidth: .infinity)
            
            HStack {
                HStack {
                    ForEach(swiftDexService.selectedVersionGroup.versions) { version in
                        Rectangle()
                            .foregroundColor(version.color)
                            .frame(height: 30)
                            .overlay(
                                Text(version.names.first(where: {$0.localLanguageId == 9})!.name)
                                    .padding(.horizontal)
                                    .minimumScaleFactor(0.5)
                                    .foregroundColor(.white)
                            )
                    }
                }
                .cornerRadius(8)
                .onTapGesture {
                    self.showVersionSelectionSheet = true
                }
                .sheet(isPresented: $showVersionSelectionSheet, content: {
                    VersionGroupSelectionView(generations: swiftDexService.generations, pokemonFormRestriction: nil, selectedVersionGroup: $swiftDexService.selectedVersionGroup, selectedVersion: $swiftDexService.selectedVersion)
                })
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(Color(.clear))
    }
}

struct TeamSummaryView: View {
    let team: Team
    
    var body: some View {
        VStack {
            HStack {
                Text(team.name)
                    .font(.title)
                    .bold()
                Spacer()
            }
            LazyVGrid(columns: [GridItem(.flexible(), spacing: 15), GridItem(.flexible(), spacing: 15), GridItem(.flexible(), spacing: 15)], spacing: 15) {
                ForEach(0...5, id: \.self) { index in
                    let pokemon: TeamPokemon? = team.pokemon.count > index ? team.pokemon[index] : nil
                    TeamMemberSummaryView(pokemon: pokemon)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
    }
}

struct TeamMemberSummaryView: View {
    let pokemon: TeamPokemon?
    
    private var backgroundColor: Color {
        if let pokemon = pokemon {
            return pokemon.pokemon.color.opacity(0.25)
        }
        
        return Color(.secondarySystemBackground)
    }
    
    var body: some View {
        KFImage(URL(string: pokemon?.pokemon.spriteImageLink ?? ""))
            .resizable()
            .scaledToFit()
            .padding()
            .background(backgroundColor)
            .cornerRadius(10)
    }
}

struct TeamBuilderView_Previews: PreviewProvider {
    static var previews: some View {
        TeamBuilderView().environmentObject(SwiftDexService())
        
        TeamDetailView(team: .constant(testTeams[0]))
    }
}

#if DEBUG

let swiftDexService = SwiftDexService()
let testTeams: [Team] = [
    Team(name: "Team 1", pokemon: [
        TeamPokemon(pokemon: swiftDexService.pokemon(withId: Int.random(in: 0...800))!),
        TeamPokemon(pokemon: swiftDexService.pokemon(withId: Int.random(in: 0...800))!),
        TeamPokemon(pokemon: swiftDexService.pokemon(withId: Int.random(in: 0...800))!),
        TeamPokemon(pokemon: swiftDexService.pokemon(withId: Int.random(in: 0...800))!),
        TeamPokemon(pokemon: swiftDexService.pokemon(withId: Int.random(in: 0...800))!)
    ]),
    Team(name: "Team 2", pokemon: [
        TeamPokemon(pokemon: swiftDexService.pokemon(withId: Int.random(in: 0...800))!),
        TeamPokemon(pokemon: swiftDexService.pokemon(withId: Int.random(in: 0...800))!),
        TeamPokemon(pokemon: swiftDexService.pokemon(withId: Int.random(in: 0...800))!),
        TeamPokemon(pokemon: swiftDexService.pokemon(withId: Int.random(in: 0...800))!),
        TeamPokemon(pokemon: swiftDexService.pokemon(withId: Int.random(in: 0...800))!),
        TeamPokemon(pokemon: swiftDexService.pokemon(withId: Int.random(in: 0...800))!)
    ]),
    Team(name: "Team 3", pokemon: [
        TeamPokemon(pokemon: swiftDexService.pokemon(withId: Int.random(in: 0...800))!),
        TeamPokemon(pokemon: swiftDexService.pokemon(withId: Int.random(in: 0...800))!),
        TeamPokemon(pokemon: swiftDexService.pokemon(withId: Int.random(in: 0...800))!),
        TeamPokemon(pokemon: swiftDexService.pokemon(withId: Int.random(in: 0...800))!),
        TeamPokemon(pokemon: swiftDexService.pokemon(withId: Int.random(in: 0...800))!),
        TeamPokemon(pokemon: swiftDexService.pokemon(withId: Int.random(in: 0...800))!)
    ]),
    Team(name: "Team 4", pokemon: [
        TeamPokemon(pokemon: swiftDexService.pokemon(withId: Int.random(in: 0...800))!),
        TeamPokemon(pokemon: swiftDexService.pokemon(withId: Int.random(in: 0...800))!),
        TeamPokemon(pokemon: swiftDexService.pokemon(withId: Int.random(in: 0...800))!),
        TeamPokemon(pokemon: swiftDexService.pokemon(withId: Int.random(in: 0...800))!),
        TeamPokemon(pokemon: swiftDexService.pokemon(withId: Int.random(in: 0...800))!),
        TeamPokemon(pokemon: swiftDexService.pokemon(withId: Int.random(in: 0...800))!)
    ])
]
#endif


struct TeamMembersDetailView: View {
    @Binding var team: Team
    
    @State private var showTeamPokemonDetailView: Bool = false
    @State private var selectedTeamPokemonIndex: Int = 0
    @State private var selectedTeamPokemon: Binding<TeamPokemon>?
    @State private var editingTeamMembers: Bool = false
    @State private var rotationAmount: Double = 0
    @GestureState private var draggingPokemonViewOffset: CGSize = CGSize.zero
    @State private var draggingPokemon: TeamPokemon?
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible(), spacing: 15), GridItem(.flexible(), spacing: 15), GridItem(.flexible(), spacing: 15)], spacing: 15) {
            ForEach(0...5, id: \.self) { index in
                if team.pokemon.count > index {
                    ZStack {
                        TeamMemberDetailView(pokemon: team.pokemon[index])
                            .rotationEffect(Angle.degrees(editingTeamMembers ? 6 : 0))
                            .animation(editingTeamMembers ? Animation.default.repeatForever() : Animation.default)
                            .rotationEffect(Angle.degrees(rotationAmount))
                            .animation(Animation.default)
                            .offset(x: draggingPokemon == team.pokemon[index] ? draggingPokemonViewOffset.width : 0)
                            .offset(y: draggingPokemon == team.pokemon[index] ? draggingPokemonViewOffset.height : 0)
                            .gesture(TapGesture(count: 1).onEnded() { _ in
                                if editingTeamMembers {
                                    editingTeamMembers = false
                                    rotationAmount = 0
                                } else {
                                    selectedTeamPokemon = $team.pokemon[index]
                                    selectedTeamPokemonIndex = index
                                    showTeamPokemonDetailView = true
                                }
                            }
                            .exclusively(before: LongPressGesture().onEnded() { _ in
                                if !editingTeamMembers {
                                    editingTeamMembers = true
                                    rotationAmount = -3
                                    return
                                }
                                
                                self.draggingPokemon = team.pokemon[index]
                            }
                            .sequenced(before: DragGesture().updating($draggingPokemonViewOffset, body: { (value, state, transaction) in
                                print(value.translation)
                                state = value.translation
                            }).onEnded() { value in
                                
                            })))
                        
                        if editingTeamMembers {
                            VStack {
                                HStack {
                                    Spacer()
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.system(size: 30))
                                        .foregroundColor(Color(.secondaryLabel))
                                        .zIndex(1)
                                        .offset(x: draggingPokemon == team.pokemon[index] ? draggingPokemonViewOffset.width : 0)
                                        .offset(y: draggingPokemon == team.pokemon[index] ? draggingPokemonViewOffset.height : 0)
                                        .animation(.default)
                                        .offset(x: 10, y: -10)
                                        .highPriorityGesture(TapGesture().onEnded() { _ in
                                            team.pokemon.remove(at: index)
                                        })
                                }
                                Spacer()
                            }
                        }
                    }
                    .zIndex(draggingPokemon == team.pokemon[index] ? 1 : 0)
                } else {
                    TeamMemberEmptyDetailView()
                }
            }
        }
    }
}
