//
//  TeamDetailView.swift
//  Pokedex
//
//  Created by TempUser on 2/6/21.
//

import SwiftUI
import Kingfisher

struct TeamDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TeamDetailView(team: testTeams[0]).environmentObject(PokemonShowdownService()).environmentObject(SwiftDexService())
    }
}

struct Shake: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
            amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
            y: 0))
    }
}

struct TeamDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var pokemonShowdownService: PokemonShowdownService
    @EnvironmentObject var swiftDexService: SwiftDexService
    
    @State var team: Team
    
    @State private var shakeTeamName: Int = 0
    @State private var shakePokemonCount: Int = 0
    
    @State private var showDeleteConfirmationAlert: Bool = false
    
    @State private var showFormatSelectionView: Bool = false
    
//    @State private var selectedGeneration: Generation
//    @State private var selectedFormat: ShowdownFormat
    
    init(team: Team) {
        _team = State(initialValue: team)
    }
    
    var body: some View {
        VStack {
            HStack {
                Button("Discard") {
                    presentationMode.wrappedValue.dismiss()
                }
                Spacer()
                Button("Save") {
                    if team.name.isEmpty {
                        withAnimation {
                            shakeTeamName += 1
                        }
                    }
                    
                    if team.pokemon.count == 0 {
                        withAnimation {
                            shakePokemonCount += 1
                        }
                    }
                    
                    if !team.name.isEmpty && team.pokemon.count > 0 {
                        pokemonShowdownService.saveTeam(team)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
            }
            .padding(.horizontal)
            ScrollView {
                VStack(spacing: 20) {
                    VStack(spacing: 2) {
                        TextField("Team Name", text: $team.name)
                            .font(.title)
                            .disableAutocorrection(true)
                            .modifier(Shake(animatableData: CGFloat(shakeTeamName)))
                            .modifier(ClearButton(text: $team.name))
                        Rectangle()
                            .frame(height: 2)
                            .foregroundColor(Color(.secondarySystemFill))
                    }
                    
                    HStack {
                        Button(action: {
                            showFormatSelectionView = true
                        }, label: {
                            Text(team.format.identifier)
                                .padding(10)
                                .background(Color(.secondarySystemFill))
                                .foregroundColor(Color(.secondaryLabel))
                                .cornerRadius(8)
                        })
                        .sheet(isPresented: $showFormatSelectionView, content: {
                            TeamFormatSelectionView(formats: swiftDexService.showdownFormats.compactMap({$0}), selectedFormat: $team.format, showView: $showFormatSelectionView)
                        })
                        
                        Spacer()
                    }
                    
                    TeamMembersDetailView(team: $team).environmentObject(pokemonShowdownService)
                        .modifier(Shake(animatableData: CGFloat(shakePokemonCount)))
                    
                    TeamStatAvgView(hpAvg: team.hpAvg, atkAvg: team.atkAvg, defAvg: team.defAvg, satkAvg: team.satkAvg, sdefAvg: team.sdefAvg, speAvg: team.speAvg)
                    
                    Button(action: {
                        showDeleteConfirmationAlert = true
                    }, label: {
                        HStack(spacing: 2) {
                            Image(systemName: "trash")
                                .font(.title2)
                                .foregroundColor(Color(.systemRed))
                            Text("Delete Team")
                                .font(.title2)
                                .foregroundColor(Color(.systemRed))
                        }
                    })
                    .alert(isPresented: $showDeleteConfirmationAlert, content: {
                        Alert(title: Text("Delete Team"), message: Text("Are you sure? You can't undo this action."), primaryButton: Alert.Button.destructive(Text("Delete Team"), action: {
                            pokemonShowdownService.deleteTeam(team)
                            presentationMode.wrappedValue.dismiss()
                        }), secondaryButton: Alert.Button.cancel())
                    })
                    Spacer()
                }
                .padding()
            }
        }
    }
}

struct TeamFormatSelectionView: View {
    let formats: [ShowdownFormat]
    @Binding var selectedFormat: ShowdownFormat
    @Binding var showView: Bool
    
    @State private var searchText: String = ""
    
    private var formatsFiltered: [ShowdownFormat] {
        return formats.filter({searchText.isEmpty ? true : $0.identifier.localizedCaseInsensitiveContains(searchText)})
    }
    
    var body: some View {
        VStack {
            TextField("Formats", text: $searchText)
                .font(.title)
                .padding()
                .modifier(ClearButton(text: $searchText))
                .disableAutocorrection(true)
            
            ScrollView {
                LazyVStack(spacing: 2) {
                    ForEach(formatsFiltered, id: \.self) { format in
                        HStack {
                            Text(format.identifier)
                                .font(.title)
                                .padding(.vertical)
                            Spacer()
                        }
                        .onTapGesture {
                            selectedFormat = format
                            showView = false
                        }
                        .padding(.horizontal)
                        .background(Color(.systemBackground))
                    }
                }
                .padding(.top, 2)
            }
            .background(Color(.secondarySystemBackground))
        }
        
    }
}

struct TeamStatAvgView: View {
    
    let hpAvg, atkAvg, defAvg, satkAvg, sdefAvg, speAvg: Int
    
    var body: some View {
        VStack {
            PokemonDetailSectionHeader(text: "Average Base Stats")
            PokemonStatView(name: "HP", color: Color(.systemGray2), baseStat: hpAvg, max: 300)
            PokemonStatView(name: "ATK", color: Color(.systemGray2), baseStat: atkAvg, max: 300)
            PokemonStatView(name: "DEF", color: Color(.systemGray2), baseStat: defAvg, max: 300)
            PokemonStatView(name: "SATK", color: Color(.systemGray2), baseStat: satkAvg, max: 300)
            PokemonStatView(name: "SDEF", color: Color(.systemGray2), baseStat: sdefAvg, max: 300)
            PokemonStatView(name: "SPE", color: Color(.systemGray2), baseStat: speAvg, max: 300)
        }
    }
}
