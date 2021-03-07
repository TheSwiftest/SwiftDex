//
//  BattleSimulatorView.swift
//  Pokedex
//
//  Created by BrianCorbin on 2/3/21.
//

import SwiftUI

struct BattleSimulatorView_Previews: PreviewProvider {
    static var previews: some View {
        BattleSimulatorView().environmentObject(SwiftDexService()).environmentObject(PokemonShowdownService())
    }
}

struct BattleSimulatorView: View {
    fileprivate enum Weather {
        case none, rain, harshSunlight
    }

    private let movesAffectingMinimizedDefender: [String] = [
        "astonish", "body-slam", "dragon-rush", "extrasensory", "flying-press", "heat-crash", "heavy-slam", "needle-arm", "phantom-force", "shadow-force", "stomp"
    ]

    private let movesAffectingDiveDefender: [String] = [
        "surf", "whirlpool"
    ]

    private let movesAffectingDigDefender: [String] = [
        "earthquake"
    ]

    @EnvironmentObject var swiftDexService: SwiftDexService
    @EnvironmentObject var pokemonShowdownService: PokemonShowdownService

    @State private var attackingPokemon: TeamPokemon?
    @State private var defendingPokemon: TeamPokemon?

    @State private var selectedMove: Move?
    @State private var wonderRoom: Bool = false
    @State private var criticalHit: Bool = false
    @State private var attackerBurned: Bool = false
    @State private var defenderMinimized: Bool = false
    @State private var defenderUsingDig: Bool = false
    @State private var defenderUsingDive: Bool = false
    @State private var auroraVeilActive: Bool = false
    @State private var lightScreenActive: Bool = false
    @State private var reflectActive: Bool = false
    @State private var defenderAtFullHealth: Bool = true
    @State private var weather: Weather = .none
    @State private var allyHasFriendGuard: Bool = false
    @State private var otherMods: CGFloat = 1.0

    private var maxDamage: Int {
        guard let attackingPokemon = attackingPokemon, let defendingPokemon = defendingPokemon, let move = selectedMove else {
            return 0
        }

        let attackStat = move.damageClass?.id == 2 ? attackingPokemon.totAtk : attackingPokemon.totSatk
        let defenseStat = move.damageClass?.id == 2 ? defendingPokemon.totDef : defendingPokemon.totSdef

        var result = ((2 * attackingPokemon.level) / 5) + 2
        result *= move.power.value ?? 0
        result *= attackStat
        result /= defenseStat
        result /= 50
        result += 2

        var modifier: CGFloat = 1.0

        // STAB Bonus
        if let moveType = move.type, attackingPokemon.pokemon.types.map({ $0.type }).contains(moveType) {
            if attackingPokemon.ability?.identifier == "adaptability" {
                modifier *= 2.0
            } else {
                modifier *= 1.5
            }
        }

        // Weather Bonus
        if let moveType = move.type {
            if (moveType.typeData == .water && weather == .rain) || (moveType.typeData == .fire && weather == .harshSunlight) {
                modifier *= 1.5
            }

            if (moveType.typeData == .water && weather == .harshSunlight) || (moveType.typeData == .fire && weather == .rain) {
                modifier *= 0.5
            }
        }

        // Critical Hit
        if criticalHit {
            modifier *= 1.5
        }

        // Attacker Burned
        if attackerBurned && move.damageClass?.identifier == "physical" && attackingPokemon.ability?.identifier != "guts" {
            modifier *= 0.5
        }

        // Type Effectiveness Bonus
        var effectiveness = TypeEffectiveness.Effectiveness.normal

        if let moveType = move.type?.typeData {
            for type in defendingPokemon.pokemon.types {
                effectiveness = effectiveness.combined(with: type.type!.typeData.damageEffectiveness(from: moveType))
            }
        }

        // Special Cases
        if (defenderMinimized && (movesAffectingMinimizedDefender.contains(move.identifier))) ||
            (defenderUsingDig && (movesAffectingDigDefender.contains(move.identifier))) ||
            (defenderUsingDive && (movesAffectingDiveDefender.contains(move.identifier))) {
            modifier *= 2
        }

        // AuroraVeil, LightScreen, Reflect Special Cases
        if (auroraVeilActive || (lightScreenActive && move.damageClass?.identifier == "special") || (reflectActive && move.damageClass?.identifier == "physical"))
            && !criticalHit && attackingPokemon.ability?.identifier != "infiltrator"
            && defendingPokemon.ability?.identifier != "screen-cleaner" {
            modifier *= 0.5
        }

        // Fluffy Special Case
        // swiftlint:disable:next contains_over_filter_is_empty
        if defendingPokemon.ability?.identifier == "fluffy" && !move.flags.filter("moveFlag.identifier == 'contact'").isEmpty && move.type?.typeData != .fire {
            modifier *= 0.5
        }

        // swiftlint:disable:next contains_over_filter_is_empty
        if defendingPokemon.ability?.identifier == "fluffy" && move.flags.filter("moveFlag.identifier == 'contact'").isEmpty && move.type?.typeData == .fire {
            modifier *= 2.0
        }

        if defendingPokemon.ability?.identifier == "filter" && effectiveness.rawValue > 1.0 {
            modifier *= 0.75
        }

        if allyHasFriendGuard {
            modifier *= 0.75
        }

        if defendingPokemon.ability?.identifier == "ice-scales" && move.damageClass?.identifier == "special" {
            modifier *= 0.5
        }

        if defendingPokemon.ability?.identifier == "multiscale" && defenderAtFullHealth {
            modifier *= 0.5
        }

        if defendingPokemon.ability?.identifier == "shadow-shield" && defenderAtFullHealth {
            modifier *= 0.5
        }

        if attackingPokemon.ability?.identifier == "neuroforce" && effectiveness.rawValue > 1.0 {
            modifier *= 1.25
        }

        if defendingPokemon.ability?.identifier == "prism-armor" && effectiveness.rawValue > 1.0 {
            modifier *= 0.75
        }

        // swiftlint:disable:next contains_over_filter_is_empty
        if defendingPokemon.ability?.identifier == "punk-rock" && !move.flags.filter("moveFlag.identifier == 'sound'").isEmpty {
            modifier *= 0.5
        }

        if attackingPokemon.ability?.identifier == "sniper" && criticalHit {
            modifier *= 1.5
        }

        if defendingPokemon.ability?.identifier == "solid-rock" && effectiveness.rawValue > 1.0 {
            modifier *= 0.75
        }

        if attackingPokemon.ability?.identifier == "tinted-lens" && effectiveness.rawValue < 1.0 {
            modifier *= 2.0
        }

        if defendingPokemon.item?.identifier == "chilan-berry" && move.type?.typeData == .normal {
            modifier *= 0.5
        }

        if attackingPokemon.item?.identifier == "expert-belt" && effectiveness.rawValue > 1.0 {
            modifier *= 1.2
        }

        if attackingPokemon.item?.identifier == "life-orb" {
            modifier *= 1.3
        }

        modifier *= CGFloat(effectiveness.rawValue)

        modifier *= otherMods

        return Int(CGFloat(result) * modifier)
    }

    private var minDamage: Int {
        return Int(CGFloat(maxDamage) * 0.85)
    }

    private var avgDamage: Int {
        return (maxDamage + minDamage) / 2
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                HStack(spacing: 20) {
                    VStack {
                        Text("Attacker")
                            .font(.title2)
                        BattleSimPokemonView(pokemon: $attackingPokemon).environmentObject(swiftDexService).environmentObject(pokemonShowdownService)
                    }
                    VStack {
                        Text("Defender")
                            .font(.title2)
                        BattleSimPokemonView(pokemon: $defendingPokemon).environmentObject(swiftDexService).environmentObject(pokemonShowdownService)
                    }
                }

                BattleSimAttackingMoveView(selectedMove: $selectedMove, attackingPokemon: attackingPokemon, defendingPokemon: defendingPokemon).environmentObject(swiftDexService)

                BattleSimDamageView(maxDamage: maxDamage, minDamage: minDamage, avgDamage: avgDamage,
                                    attackingPokemon: attackingPokemon, defendingPokemon: defendingPokemon, selectedMove: selectedMove)

                BattleSimWeatherView(weather: $weather)

                BattleSimModifiersView(defenderAtFullHealth: $defenderAtFullHealth, wonderRoom: $wonderRoom, criticalHit: $criticalHit,
                                       attackerBurned: $attackerBurned, defenderMinimized: $defenderMinimized,
                                       defenderDigging: $defenderUsingDig, defenderDiving: $defenderUsingDive,
                                       reflectActive: $reflectActive, lightScreenActive: $lightScreenActive,
                                       auroraVeilActive: $auroraVeilActive, allyHasFriendGuard: $allyHasFriendGuard)
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
        return swiftDexService.items.compactMap({ $0 })
    }

    private var natures: [Nature] {
        return swiftDexService.natures.compactMap({ $0 })
    }

    var body: some View {
        VStack(spacing: 0) {
            TeamPokemonSummaryView(pokemon: teamPokemon.pokemon, shiny: teamPokemon.shiny)
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    TeamPokemonNicknameAndGenderView(genders: [swiftDexService.male, swiftDexService.female], nickname: $teamPokemon.nickname,
                                                     gender: $teamPokemon.gender, color: teamPokemon.pokemon.color)
                    TeamPokemonAbilitiesView(pokemonAbilities: teamPokemon.pokemon.abilities.compactMap({ $0 }), color: teamPokemon.pokemon.color, ability: $teamPokemon.ability)
                    TeamPokemonLevelAndHappinessView(level: $teamPokemon.level, happiness: $teamPokemon.happiness, color: teamPokemon.pokemon.color, shiny: $teamPokemon.shiny)
                    TeamPokemonNatureAndItemView(availableNatures: natures, availableItems: items, nature: $teamPokemon.nature, item: $teamPokemon.item)
                    TeamPokemonStatsView(pokemonStats: teamPokemon.pokemon.stats.compactMap({ $0 }), nature: teamPokemon.nature, evs: teamPokemon.evs, ivs: teamPokemon.ivs, level: teamPokemon.level)
                    TeamPokemonEVsView(evs: $teamPokemon.evs, color: teamPokemon.pokemon.color)
                    TeamPokemonIVsView(ivs: $teamPokemon.ivs, color: teamPokemon.pokemon.color)
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
    @Binding fileprivate var weather: BattleSimulatorView.Weather

    var body: some View {
        VStack {
            Text("Weather")
                .font(.title2)
                .bold()
            HStack {
                Picker(selection: $weather, label: Text("Picker"), content: {
                    Text("None").tag(BattleSimulatorView.Weather.none)
                    Text("Rainy").tag(BattleSimulatorView.Weather.rain)
                    Text("Sunny").tag(BattleSimulatorView.Weather.harshSunlight)
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
    @EnvironmentObject var swiftDexService: SwiftDexService

    @Binding var selectedMove: Move?
    let attackingPokemon: TeamPokemon?
    let defendingPokemon: TeamPokemon?

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

    var body: some View {
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
    }
}

struct BattleSimPokemonView: View {
    @EnvironmentObject var swiftDexService: SwiftDexService
    @EnvironmentObject var pokemonShowdownService: PokemonShowdownService

    @Binding var pokemon: TeamPokemon?
    @State private var showPokemonEditView: Bool = false
    @State private var showPokemonSelectionSheet: Bool = false
    @State private var selectingPokemon: Bool = false

    var body: some View {
        if let pokemon = pokemon {
            ZStack {
                TeamMemberDetailView(pokemon: pokemon)
                    .onTapGesture {
                        showPokemonEditView = true
                    }
                    .sheet(isPresented: $showPokemonEditView, content: {
                        BattlePokemonDetailView(teamPokemon: $pokemon).environmentObject(swiftDexService)
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
                BattleSimPokemonSelectionView(pokemon: $pokemon).environmentObject(swiftDexService)
            }
        }
    }
}
