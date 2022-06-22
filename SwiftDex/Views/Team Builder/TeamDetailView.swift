//
//  TeamDetailView.swift
//  SwiftDex
//
//  Created by Brian Corbin on 6/22/22.
//

import SwiftUI

struct Shake: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX: amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)), y: 0))
    }
}

struct TeamDetailView: View {
    @Environment(\.presentationMode) var presentationMode

    @EnvironmentObject var pokemonShowdownService: PokemonShowdownService

    @State var team: Team

    @State private var shakeTeamName: Int = 0
    @State private var shakePokemonCount: Int = 0

    @State private var showDeleteConfirmationAlert = false

    @State private var showFormatSelectionView = false

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

                    if team.pokemon.isEmpty {
                        withAnimation {
                            shakePokemonCount += 1
                        }
                    }

                    if !team.name.isEmpty && !team.pokemon.isEmpty {
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
                            TeamFormatSelectionView(formats: SwiftDexService.showdownFormats.compactMap({ $0 }), selectedFormat: $team.format, showView: $showFormatSelectionView)
                        })

                        Spacer()
                    }

                    TeamMembersDetailView(team: $team).environmentObject(pokemonShowdownService)
                        .modifier(Shake(animatableData: CGFloat(shakePokemonCount)))

                    TeamStatsAvgView(baseHp: team.baseHpAvg, baseAtk: team.baseAtkAvg, baseDef: team.baseDefAvg, baseSatk: team.baseSatkAvg,
                                     baseSdef: team.baseSdefAvg, baseSpe: team.baseSpeAvg, totHp: team.totHpAvg, totAtk: team.totAtkAvg,
                                     totDef: team.totDefAvg, totSatk: team.totSatkAvg, totSdef: team.totSdefAvg, totSpe: team.totSpeAvg)

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
        return formats.filter({ searchText.isEmpty ? true : $0.identifier.localizedCaseInsensitiveContains(searchText) })
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

struct TeamStatsAvgView: View {
    let baseHp, baseAtk, baseDef, baseSatk, baseSdef, baseSpe: Int
    let totHp, totAtk, totDef, totSatk, totSdef, totSpe: Int

    @State private var showTotals = false

    var body: some View {
        VStack {
            VStack(spacing: 5) {
                PokemonDetailSectionHeader(text: "Average Stats")
                HStack {
                    Spacer()
                        .frame(maxWidth: .infinity)
                    Picker("", selection: $showTotals) {
                        Text("Base").tag(false)
                        Text("Total").tag(true)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    Spacer()
                        .frame(maxWidth: .infinity)
                }
            }

            PokemonStatInfoView(name: "HP", color: Color(.systemGray2), baseStat: showTotals ? totHp : baseHp, max: showTotals ? 714 : 255)
            PokemonStatInfoView(name: "ATK", color: Color(.systemGray2), baseStat: showTotals ? totAtk : baseAtk, max: showTotals ? 526 : 190)
            PokemonStatInfoView(name: "DEF", color: Color(.systemGray2), baseStat: showTotals ? totDef : baseDef, max: showTotals ? 658 : 250)
            PokemonStatInfoView(name: "SATK", color: Color(.systemGray2), baseStat: showTotals ? totSatk : baseSatk, max: showTotals ? 535 : 194)
            PokemonStatInfoView(name: "SDEF", color: Color(.systemGray2), baseStat: showTotals ? totSdef : baseSdef, max: showTotals ? 658 : 250)
            PokemonStatInfoView(name: "SPE", color: Color(.systemGray2), baseStat: showTotals ? totSpe : baseSpe, max: showTotals ? 548 : 200)
        }
    }
}

struct TeamDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TeamDetailView(team: testTeams[0]).environmentObject(PokemonShowdownService())
    }
}
