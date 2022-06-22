//
//  BattleSimulatorViewModel.swift
//  Pokedex
//
//  Created by Brian Corbin on 3/8/21.
//

import Foundation
import UIKit

class BattleSimulatorViewModel: ObservableObject {
    enum Weather {
        case none, rain, harshSunlight
    }

    @Published var attackingPokemon: TeamPokemon?
    @Published var defendingPokemon: TeamPokemon?

    @Published var selectedMove: Move?
    @Published var wonderRoom = false
    @Published var criticalHit = false
    @Published var attackerBurned = false
    @Published var defenderMinimized = false
    @Published var defenderUsingDig = false
    @Published var defenderUsingDive = false
    @Published var auroraVeilActive = false
    @Published var lightScreenActive = false
    @Published var reflectActive = false
    @Published var defenderAtFullHealth = true
    @Published var weather: Weather = .none
    @Published var allyHasFriendGuard = false
    @Published var otherMods: CGFloat = 1.0

    private let movesAffectingMinimizedDefender: [String] = [
        "astonish", "body-slam", "dragon-rush", "extrasensory", "flying-press", "heat-crash", "heavy-slam", "needle-arm", "phantom-force", "shadow-force", "stomp"
    ]

    private let movesAffectingDiveDefender: [String] = [
        "surf", "whirlpool"
    ]

    private let movesAffectingDigDefender: [String] = [
        "earthquake"
    ]

    var maxDamage: Int {
        guard let attackingPokemon = attackingPokemon, let defendingPokemon = defendingPokemon, let move = selectedMove else {
            return 0
        }

        let attackStat = move.damageClass?.id == 2 ? attackingPokemon.totAtk : attackingPokemon.totSatk
        let defenseStat = move.damageClass?.id == 2 ? defendingPokemon.totDef : defendingPokemon.totSdef

        var result = ((2 * attackingPokemon.level) / 5) + 2
        result *= move.power ?? 0
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

    var minDamage: Int {
        return Int(CGFloat(maxDamage) * 0.85)
    }

    var avgDamage: Int {
        return (maxDamage + minDamage) / 2
    }
}
