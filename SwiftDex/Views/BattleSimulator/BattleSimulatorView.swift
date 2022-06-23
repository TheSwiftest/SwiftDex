//
//  BattleSimulatorView.swift
//  SwiftDex
//
//  Created by BrianCorbin on 2/3/21.
//

import SwiftUI

struct BattleSimulatorView_Previews: PreviewProvider {
    static var previews: some View {
        BattleSimulatorView().environmentObject(PokemonShowdownService())
    }
}

struct BattleSimulatorView: View {
    @EnvironmentObject var pokemonShowdownService: PokemonShowdownService

    @ObservedObject private var viewModel = BattleSimulatorViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                HStack(spacing: 20) {
                    VStack {
                        Text("Attacker")
                            .font(.title2)
                        BattleSimPokemonView(pokemon: $viewModel.attackingPokemon).environmentObject(pokemonShowdownService)
                    }
                    VStack {
                        Text("Defender")
                            .font(.title2)
                        BattleSimPokemonView(pokemon: $viewModel.defendingPokemon).environmentObject(pokemonShowdownService)
                    }
                }

                BattleSimAttackingMoveView(selectedMove: $viewModel.selectedMove, attackingPokemon: viewModel.attackingPokemon, defendingPokemon: viewModel.defendingPokemon)

                BattleSimDamageView(maxDamage: viewModel.maxDamage, minDamage: viewModel.minDamage, avgDamage: viewModel.avgDamage,
                                    attackingPokemon: viewModel.attackingPokemon, defendingPokemon: viewModel.defendingPokemon, selectedMove: viewModel.selectedMove)

                BattleSimWeatherView(weather: $viewModel.weather)

                BattleSimModifiersView(defenderAtFullHealth: $viewModel.defenderAtFullHealth, wonderRoom: $viewModel.wonderRoom, criticalHit: $viewModel.criticalHit,
                                       attackerBurned: $viewModel.attackerBurned, defenderMinimized: $viewModel.defenderMinimized,
                                       defenderDigging: $viewModel.defenderUsingDig, defenderDiving: $viewModel.defenderUsingDive,
                                       reflectActive: $viewModel.reflectActive, lightScreenActive: $viewModel.lightScreenActive,
                                       auroraVeilActive: $viewModel.auroraVeilActive, allyHasFriendGuard: $viewModel.allyHasFriendGuard)
            }
            .padding()
        }
    }
}

struct BattleSimPokemonSelectionView: View {
    @Environment(\.presentationMode) var presentationMode

    @Binding var pokemon: TeamPokemon?

    @State private var searchText: String = ""

    var body: some View {
        VStack(spacing: 0) {
            TextField("Search Pokemon", text: $searchText)
                .font(.title)
                .modifier(ClearButton(text: $searchText))
                .padding()
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 10) {
                    ForEach(SwiftDexService.pokemon(matching: searchText)) { pokemon in
                        MemberSummaryView(pokemon: pokemon, shiny: false)
                            .onTapGesture {
                                self.pokemon = TeamPokemon(pokemon: pokemon)
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

struct BattlePokemonDetailView: View {
    @Binding private var teamPokemonOriginal: TeamPokemon?
    @State private var teamPokemon: TeamPokemon

    init(teamPokemon: Binding<TeamPokemon?>) {
        _teamPokemonOriginal = teamPokemon
        _teamPokemon = State(initialValue: teamPokemon.wrappedValue!)
    }

    var body: some View {
        VStack(spacing: 0) {
            MemberSummaryView(pokemon: teamPokemon.pokemon, shiny: teamPokemon.shiny)
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    MemberNicknameGenderView(genders: [SwiftDexService.male, SwiftDexService.female], nickname: $teamPokemon.nickname,
                                                     gender: $teamPokemon.gender, color: teamPokemon.pokemon.color)
                    MemberAbilitiesView(slot1Ability: teamPokemon.pokemon.slot1Ability, slot2Ability: teamPokemon.pokemon.slot2Ability, slot3Ability: teamPokemon.pokemon.slot3Ability, color: teamPokemon.pokemon.color, ability: $teamPokemon.ability)
                    MemberLevelHappyShinyView(level: $teamPokemon.level, happiness: $teamPokemon.happiness, color: teamPokemon.pokemon.color, shiny: $teamPokemon.shiny)
                    MemberNatureAndItemView(availableNatures: SwiftDexService.natures, availableItems: SwiftDexService.items, nature: $teamPokemon.nature, item: $teamPokemon.item)
                    MemberStatsView(pokemonStats: teamPokemon.pokemon.stats.compactMap({ $0 }), nature: teamPokemon.nature, evs: teamPokemon.evs, ivs: teamPokemon.ivs, level: teamPokemon.level)
                    MemberEVsView(evs: $teamPokemon.evs, color: teamPokemon.pokemon.color)
                    MemberIVsView(ivs: $teamPokemon.ivs, color: teamPokemon.pokemon.color)
                }
                .padding()
            }
        }
        .onDisappear {
            _teamPokemonOriginal.wrappedValue = _teamPokemon.wrappedValue
        }
    }
}

struct BattleSimModifiersView: View {
    @Binding var defenderAtFullHealth: Bool
    @Binding var wonderRoom: Bool
    @Binding var criticalHit: Bool
    @Binding var attackerBurned: Bool
    @Binding var defenderMinimized: Bool
    @Binding var defenderDigging: Bool
    @Binding var defenderDiving: Bool
    @Binding var reflectActive: Bool
    @Binding var lightScreenActive: Bool
    @Binding var auroraVeilActive: Bool
    @Binding var allyHasFriendGuard: Bool

    var body: some View {
        VStack {
            VStack {
                Text("Modifiers")
                    .font(.title2)
                    .bold()
                Toggle(isOn: $defenderAtFullHealth, label: {
                    Text("Defender at Full HP")
                })
                Toggle(isOn: $wonderRoom, label: {
                    Text("Wonder Room")
                })
                Toggle(isOn: $criticalHit, label: {
                    Text("Critical Hit")
                })
                Toggle(isOn: $attackerBurned, label: {
                    Text("Attacker Burned")
                })
                Toggle(isOn: $defenderMinimized, label: {
                    Text("Defender Minimized")
                })
                Toggle(isOn: $defenderDigging, label: {
                    Text("Defender Digging")
                })
                Toggle(isOn: $defenderDiving, label: {
                    Text("Defender Diving")
                })
            }
            VStack {
                Toggle(isOn: $reflectActive, label: {
                    Text("Reflect Active")
                })
                Toggle(isOn: $lightScreenActive, label: {
                    Text("Light Screen Active")
                })
                Toggle(isOn: $auroraVeilActive, label: {
                    Text("Aurora Veil Active")
                })

                Toggle(isOn: $allyHasFriendGuard, label: {
                    Text("Ally has Friend Guard")
                })
            }
        }
    }
}

struct BattleSimWeatherView: View {
    @Binding var weather: BattleSimulatorViewModel.Weather

    var body: some View {
        VStack {
            Text("Weather")
                .font(.title2)
                .bold()
            HStack {
                Picker(selection: $weather, label: Text("Picker"), content: {
                    Text("None").tag(BattleSimulatorViewModel.Weather.none)
                    Text("Rainy").tag(BattleSimulatorViewModel.Weather.rain)
                    Text("Sunny").tag(BattleSimulatorViewModel.Weather.harshSunlight)
                })
                .pickerStyle(SegmentedPickerStyle())
            }
        }
    }
}

struct BattleSimDamageView: View {
    let maxDamage: Int
    let minDamage: Int
    let avgDamage: Int

    let attackingPokemon: TeamPokemon?
    let defendingPokemon: TeamPokemon?
    let selectedMove: Move?

    private var maxDamageHPPercent: String {
        guard let defendingPokemon = defendingPokemon else {
            return "-%"
        }

        let res = CGFloat(maxDamage) / CGFloat(defendingPokemon.totHp)
        return String(format: "%.2f%%", res * 100)
    }

    private var minDamageHPPercent: String {
        guard let defendingPokemon = defendingPokemon else {
            return "-%"
        }

        let res = CGFloat(minDamage) / CGFloat(defendingPokemon.totHp)
        return String(format: "%.2f%%", res * 100)
    }

    private var avgDamageHPPercent: String {
        guard let defendingPokemon = defendingPokemon else {
            return "-%"
        }

        let res = CGFloat(avgDamage) / CGFloat(defendingPokemon.totHp)
        return String(format: "%.2f%%", res * 100)
    }

    var body: some View {
        VStack(spacing: 10) {
            Text("Damage")
                .font(.title2)
                .bold()

            HStack {
                VStack {
                    Text("MIN")
                        .frame(maxWidth: .infinity)
                    Text("\(minDamage)")
                        .font(.title)
                        .bold()
                    Text(minDamageHPPercent)
                        .font(.caption)
                }

                VStack {
                    Text("MAX")
                        .frame(maxWidth: .infinity)
                    Text("\(maxDamage)")
                        .font(.title)
                        .bold()
                    Text(maxDamageHPPercent)
                        .font(.caption)
                }

                VStack {
                    Text("AVG")
                        .frame(maxWidth: .infinity)
                    Text("\(avgDamage)")
                        .font(.title)
                        .bold()
                    Text(avgDamageHPPercent)
                        .font(.caption)
                }
            }
        }
    }
}

struct BattleSimAttackingMoveView: View {
    @Binding var selectedMove: Move?
    let attackingPokemon: TeamPokemon?
    let defendingPokemon: TeamPokemon?

    private var powerText: String {
        guard let power = selectedMove?.power else {
            return "-"
        }

        return "\(power)"
    }

    private var accuracyText: String {
        guard let accuracy = selectedMove?.accuracy else {
            return "-"
        }

        return "\(accuracy)"
    }

    private var ppText: String {
        guard let pp = selectedMove?.pp else {
            return "-"
        }

        return "\(pp)"
    }

    private var prioText: String {
        guard let prio = selectedMove?.priority else {
            return "-"
        }

        return "\(prio)"
    }

    private var effectivenessText: String {
        guard let moveType = selectedMove?.type?.typeData, let defendingPokemon = defendingPokemon else {
            return "-"
        }

        var effectiveness = TypeEffectiveness.Effectiveness.normal

        for type in defendingPokemon.pokemon.types {
            effectiveness = effectiveness.combined(with: type.type!.typeData.damageEffectiveness(from: moveType))
        }

        return effectiveness.text()
    }

    var body: some View {
        VStack {
            Text("Attacking Move")
                .font(.title2)
            MemberMoveView(pokemon: attackingPokemon?.pokemon, move: $selectedMove)
                .cornerRadius(8)
                .padding(.bottom, 5)
            HStack {
                VStack {
                    Text("POW")
                        .font(.title2)
                    Text(powerText)
                        .font(.title2)
                        .bold()
                }
                .frame(maxWidth: .infinity)
                VStack {
                    Text("ACC")
                        .font(.title2)
                    Text(accuracyText)
                        .font(.title2)
                        .bold()
                }
                .frame(maxWidth: .infinity)
                VStack {
                    Text("PP")
                        .font(.title2)
                    Text(ppText)
                        .font(.title2)
                        .bold()
                }
                .frame(maxWidth: .infinity)
                VStack {
                    Text("DMG")
                        .font(.title2)
                    Text(effectivenessText)
                        .font(.title2)
                        .bold()
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
}

struct BattleSimPokemonView: View {
    @EnvironmentObject var pokemonShowdownService: PokemonShowdownService

    @Binding var pokemon: TeamPokemon?
    @State private var showPokemonEditView = false
    @State private var showPokemonSelectionSheet = false
    @State private var selectingPokemon = false

    var body: some View {
        if let pokemon = pokemon {
            ZStack {
                TeamMemberDetailView(pokemon: pokemon)
                    .onTapGesture {
                        showPokemonEditView = true
                    }
                    .sheet(isPresented: $showPokemonEditView, content: {
                        BattlePokemonDetailView(teamPokemon: $pokemon)
                    })

                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        if let item = pokemon.item {
                            item.sprite.resizable()
                                .frame(width: 35, height: 35)
                                .padding(.bottom, 5)
                                .padding(.trailing, 5)
                        }
                    }
                }

                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            self.pokemon = nil
                        }, label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 35))
                                .foregroundColor(Color(.secondaryLabel))
                                .padding(.top, 5)
                                .padding(.trailing, 5)
                        })
                    }
                    Spacer()
                }
            }
        } else {
            Button(action: {
                showPokemonSelectionSheet = true
            }, label: {
                TeamMemberEmptyDetailView()
            })
            .actionSheet(isPresented: $showPokemonSelectionSheet) {
                ActionSheet(title: Text("How would you like to configure this pokemon?"), message: nil, buttons: [
                    ActionSheet.Button.default(Text("From Scratch"), action: {
                        selectingPokemon = true
                    }),
                    ActionSheet.Button.default(Text("Import From Clipboard"), action: {
                        pokemon = pokemonShowdownService.importPokemonFromClipboard()
                    }),
                    ActionSheet.Button.cancel()
                ])
            }
            .sheet(isPresented: $selectingPokemon) {
                BattleSimPokemonSelectionView(pokemon: $pokemon)
            }
        }
    }
}
