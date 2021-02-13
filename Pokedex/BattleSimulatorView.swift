//
//  BattleSimulatorView.swift
//  Pokedex
//
//  Created by TempUser on 2/3/21.
//

import SwiftUI

struct BattleSimulatorView_Previews: PreviewProvider {
    static var previews: some View {
        BattleSimulatorView().environmentObject(SwiftDexService()).environmentObject(PokemonShowdownService())
    }
}

struct BattleSimulatorView: View {
    private enum Weather {
        case none, rain, harshSunlight
    }
    
    @EnvironmentObject var swiftDexService: SwiftDexService
    @EnvironmentObject var pokemonShowdownService: PokemonShowdownService
    
    @State private var attackingPokemon: TeamPokemon? = nil
    @State private var defendingPokemon: TeamPokemon? = nil
    
    @State private var showSelectAttackingPokemonActionSheet: Bool = false
    @State private var showSelectDefendingPokemonActionSheet: Bool = false
    
    @State private var selectingAttackingPokemon: Bool = false
    @State private var selectingDefendingPokemon: Bool = false
    
    @State private var selectedMove: Move? = nil
    @State private var wonderRoom: Bool = false
    @State private var criticalHit: Bool = false
    @State private var attackerBurned: Bool = false
    @State private var weather: Weather = .none
    @State private var otherMods: CGFloat = 1.0
    
    @State private var showAttackingPokemonEditView: Bool = false
    @State private var showDefendingPokemonEditView: Bool = false
    
    private var powerText: String {
        guard let power = selectedMove?.power.value else {
            return "-"
        }
        
        return "\(power)"
    }
    
    private var accuracyText: String {
        guard let accuracy = selectedMove?.accuracy.value else {
            return "-"
        }
        
        return "\(accuracy)"
    }
    
    private var ppText: String {
        guard let pp = selectedMove?.pp.value else {
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
    
    private var maxDamage: Int {
        guard let attackingPokemon = attackingPokemon, let defendingPokemon = defendingPokemon, let move = selectedMove else {
            return 0
        }
        
        let attackStat = move.damageClass?.id == 2 ? attackingPokemon.totAtk : attackingPokemon.totSatk
        let defenseStat = move.damageClass?.id == 2 ? defendingPokemon.totDef : defendingPokemon.totSdef

        var result: Int = ((2 * attackingPokemon.level) / 5) + 2
        result *= move.power.value ?? 0
        result *= (attackStat / defenseStat)
        result /= 50
        result += 2
        
        var modifier: CGFloat = 1.0
        
        //STAB Bonus
        if let moveType = move.type, attackingPokemon.pokemon.types.map({$0.type}).contains(moveType) {
            if attackingPokemon.ability?.identifier == "adaptability" {
                modifier *= 2.0
            } else {
                modifier *= 1.5
            }
        }
        
        //Weather Bonus
        if let moveType = move.type {
            if (moveType.typeData == .water && weather == .rain) || (moveType.typeData == .fire && weather == .harshSunlight) {
                modifier *= 1.5
            }
            
            if (moveType.typeData == .water && weather == .harshSunlight) || (moveType.typeData == .fire && weather == .rain) {
                modifier *= 0.5
            }
        }
        
        //Critical Hit
        if criticalHit {
            modifier *= 1.5
        }
        
        //Attacker Burned
        if attackerBurned && move.damageClass?.identifier == "physical" && attackingPokemon.ability?.identifier != "guts" {
            modifier *= 0.5
        }
        
        //Type Effectiveness Bonus
        var effectiveness = TypeEffectiveness.Effectiveness.normal
        
        if let moveType = move.type?.typeData {
            for type in defendingPokemon.pokemon.types {
                effectiveness = effectiveness.combined(with: type.type!.typeData.damageEffectiveness(from: moveType))
            }
        }
        
        modifier *= CGFloat(effectiveness.rawValue)
        
        modifier *= otherMods
        
        
        
        return Int(CGFloat(result) * modifier)
    }
    
    private var maxDamageHPPercent: String {
        guard let defendingPokemon = defendingPokemon else {
            return "-%"
        }
        
        let res = CGFloat(maxDamage) / CGFloat(defendingPokemon.totHp)
        return String(format: "%.2f%%", res * 100)
    }
    
    private var minDamage: Int {
        return Int(CGFloat(maxDamage) * 0.85)
    }
    
    private var minDamageHPPercent: String {
        guard let defendingPokemon = defendingPokemon else {
            return "-%"
        }
        
        let res = CGFloat(minDamage) / CGFloat(defendingPokemon.totHp)
        return String(format: "%.2f%%", res * 100)
    }
    
    private var avgDamage: Int {
        return (maxDamage + minDamage) / 2
    }
    
    private var avgDamageHPPercent: String {
        guard let defendingPokemon = defendingPokemon else {
            return "-%"
        }
        
        let res = CGFloat(avgDamage) / CGFloat(defendingPokemon.totHp)
        return String(format: "%.2f%%", res * 100)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                HStack(spacing: 20) {
                    VStack {
                        Text("Attacker")
                            .font(.title2)
                        if let attacker = attackingPokemon {
                            ZStack {
                                TeamMemberDetailView(pokemon: attacker)
                                    .onTapGesture {
                                        showAttackingPokemonEditView = true
                                    }
                                    .sheet(isPresented: $showAttackingPokemonEditView, content: {
                                        BattlePokemonDetailView(teamPokemon: $attackingPokemon).environmentObject(swiftDexService)
                                    })
                                
                                VStack {
                                    HStack {
                                        Spacer()
                                        Button(action: {
                                            attackingPokemon = nil
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
                                showSelectAttackingPokemonActionSheet = true
                            }, label: {
                                TeamMemberEmptyDetailView()
                            })
                            .actionSheet(isPresented: $showSelectAttackingPokemonActionSheet) {
                                ActionSheet(title: Text("How would you like to configure this pokemon?"), message: nil, buttons: [
                                    ActionSheet.Button.default(Text("From Scratch"), action: {
                                        selectingAttackingPokemon = true
                                    }),
                                    ActionSheet.Button.default(Text("Import From Clipboard"), action: {
                                        attackingPokemon = pokemonShowdownService.importPokemonFromClipboard()
                                    }),
                                    ActionSheet.Button.cancel()
                                ])
                            }
                            .sheet(isPresented: $selectingAttackingPokemon) {
                                BattleSimPokemonSelectionView(pokemon: $attackingPokemon).environmentObject(swiftDexService)
                            }
                        }
                    }
                    VStack {
                        Text("Defender")
                            .font(.title2)
                        if let defender = defendingPokemon {
                            ZStack {
                                TeamMemberDetailView(pokemon: defender)
                                    .onTapGesture {
                                        showDefendingPokemonEditView = true
                                    }
                                    .sheet(isPresented: $showDefendingPokemonEditView, content: {
                                        BattlePokemonDetailView(teamPokemon: $defendingPokemon).environmentObject(swiftDexService)
                                })
                                VStack {
                                    HStack {
                                        Spacer()
                                        Button(action: {
                                            defendingPokemon = nil
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
                                showSelectDefendingPokemonActionSheet = true
                            }, label: {
                                TeamMemberEmptyDetailView()
                            })
                            .actionSheet(isPresented: $showSelectDefendingPokemonActionSheet) {
                                ActionSheet(title: Text("How would you like to configure this pokemon?"), message: nil, buttons: [
                                    ActionSheet.Button.default(Text("From Scratch"), action: {
                                        selectingDefendingPokemon = true
                                    }),
                                    ActionSheet.Button.default(Text("Import From Clipboard"), action: {
                                        defendingPokemon = pokemonShowdownService.importPokemonFromClipboard()
                                    }),
                                    ActionSheet.Button.cancel()
                                ])
                            }
                            .sheet(isPresented: $selectingDefendingPokemon) {
                                BattleSimPokemonSelectionView(pokemon: $defendingPokemon).environmentObject(swiftDexService)
                            }
                        }
                    }
                }
                
                VStack {
                    Text("Attacking Move")
                        .font(.title2)
                    TeamPokemonMoveView(pokemon: attackingPokemon?.pokemon, move: $selectedMove).environmentObject(swiftDexService)
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
                
                VStack {
                    Text("Modifiers")
                        .font(.title2)
                    Toggle(isOn: $wonderRoom, label: {
                        Text("Wonder Room")
                    })
                    Toggle(isOn: $criticalHit, label: {
                        Text("Critical Hit")
                    })
                    Toggle(isOn: $attackerBurned, label: {
                        Text("Attacker Burned")
                    })
                    
                    Text("Weather")
                        .font(.title2)
                    HStack {
                        Picker(selection: $weather, label: Text("Picker"), content: {
                            Text("None").tag(Weather.none)
                            Text("Rainy").tag(Weather.rain)
                            Text("Sunny").tag(Weather.harshSunlight)
                        })
                        .pickerStyle(SegmentedPickerStyle())
                    }
                }
                
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
            .padding()
        }
    }
}

struct BattleSimPokemonSelectionView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var swiftDexService: SwiftDexService
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
                    ForEach(swiftDexService.pokemon(matching: searchText)) { pokemon in
                        TeamPokemonSummaryView(pokemon: pokemon, shiny: false)
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
    @EnvironmentObject var swiftDexService: SwiftDexService
    
    @Binding private var teamPokemonOriginal: TeamPokemon?
    @State private var teamPokemon: TeamPokemon
    
    init(teamPokemon: Binding<TeamPokemon?>) {
        _teamPokemonOriginal = teamPokemon
        _teamPokemon = State(initialValue: teamPokemon.wrappedValue!)
    }
    
    private var items: [Item] {
        return swiftDexService.items.compactMap({$0})
    }
    
    private var natures: [Nature] {
        return swiftDexService.natures.compactMap({$0})
    }
    
    var body: some View {
        VStack(spacing: 0) {
            TeamPokemonSummaryView(pokemon: teamPokemon.pokemon, shiny: teamPokemon.shiny)
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    TeamPokemonNicknameAndGenderView(genders: [swiftDexService.male, swiftDexService.female], nickname: $teamPokemon.nickname, gender: $teamPokemon.gender, color: teamPokemon.pokemon.color)
                    TeamPokemonAbilitiesView(pokemonAbilities: teamPokemon.pokemon.abilities.compactMap({$0}), color: teamPokemon.pokemon.color, ability: $teamPokemon.ability)
                    TeamPokemonLevelAndHappinessView(level: $teamPokemon.level, happiness: $teamPokemon.happiness, color: teamPokemon.pokemon.color, shiny: $teamPokemon.shiny)
                    TeamPokemonNatureAndItemView(availableNatures: natures, availableItems: items, nature: $teamPokemon.nature, item: $teamPokemon.item)
                    TeamPokemonStatsView(pokemonStats: teamPokemon.pokemon.stats.compactMap({$0}), nature: teamPokemon.nature, evs: teamPokemon.evs, ivs: teamPokemon.ivs, level: teamPokemon.level)
                    TeamPokemonEVsView(evs: $teamPokemon.evs, color: teamPokemon.pokemon.color)
                    TeamPokemonIVsView(ivs: $teamPokemon.ivs, color: teamPokemon.pokemon.color)
                }
                .padding()
            }
        }
        .onDisappear() {
            _teamPokemonOriginal.wrappedValue = _teamPokemon.wrappedValue
        }
    }
}
