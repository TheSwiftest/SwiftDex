//
//  Team.swift
//  Pokedex
//
//  Created by BrianCorbin on 2/6/21.
//

import Foundation
import SwiftUI

 let swiftDexService = SwiftDexService()

struct Team: Identifiable, Equatable, Codable {
    var id = UUID()
    var name: String
    var pokemon: [TeamPokemon]
    var format: ShowdownFormat

    enum CodingKeys: CodingKey {
        case id, name, pokemon, format
    }

    var baseHpAvg: Int {
        if pokemon.isEmpty {
            return 0
        }

        return pokemon.map({ $0.pokemon.baseHP }).reduce(0, +) / pokemon.count
    }
    var baseAtkAvg: Int {
        if pokemon.isEmpty {
            return 0
        }

        return pokemon.map({ $0.pokemon.baseATK }).reduce(0, +) / pokemon.count
    }
    var baseDefAvg: Int {
        if pokemon.isEmpty {
            return 0
        }

        return pokemon.map({ $0.pokemon.baseDEF }).reduce(0, +) / pokemon.count
    }
    var baseSatkAvg: Int {
        if pokemon.isEmpty {
            return 0
        }

        return pokemon.map({ $0.pokemon.baseSATK }).reduce(0, +) / pokemon.count
    }
    var baseSdefAvg: Int {
        if pokemon.isEmpty {
            return 0
        }

        return pokemon.map({ $0.pokemon.baseSDEF }).reduce(0, +) / pokemon.count
    }
    var baseSpeAvg: Int {
        if pokemon.isEmpty {
            return 0
        }

        return pokemon.map({ $0.pokemon.baseSPE }).reduce(0, +) / pokemon.count
    }

    var totHpAvg: Int {
        if pokemon.isEmpty {
            return 0
        }

        return pokemon.map({ $0.totHp }).reduce(0, +) / pokemon.count
    }
    var totAtkAvg: Int {
        if pokemon.isEmpty {
            return 0
        }

        return pokemon.map({ $0.totAtk }).reduce(0, +) / pokemon.count
    }
    var totDefAvg: Int {
        if pokemon.isEmpty {
            return 0
        }

        return pokemon.map({ $0.totDef }).reduce(0, +) / pokemon.count
    }
    var totSatkAvg: Int {
        if pokemon.isEmpty {
            return 0
        }

        return pokemon.map({ $0.totSatk }).reduce(0, +) / pokemon.count
    }
    var totSdefAvg: Int {
        if pokemon.isEmpty {
            return 0
        }

        return pokemon.map({ $0.totSdef }).reduce(0, +) / pokemon.count
    }
    var totSpeAvg: Int {
        if pokemon.isEmpty {
            return 0
        }

        return pokemon.map({ $0.totSpe }).reduce(0, +) / pokemon.count
    }

    init(name: String = "", format: ShowdownFormat? = nil, pokemon: [TeamPokemon] = []) {
        self.name = name
        self.format = format ?? swiftDexService.showdownFormats.first!
        self.pokemon = pokemon
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(pokemon, forKey: .pokemon)
        try container.encode(format.identifier, forKey: .format)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.pokemon = try container.decode([TeamPokemon].self, forKey: .pokemon)

        if let formatIdentifier = try? container.decode(String.self, forKey: .format) {
            self.format = swiftDexService.showdownFormats.first(where: { $0.identifier == formatIdentifier })!
        } else {
            self.format = swiftDexService.showdownFormats.first!
        }
    }

    func isValid(for searchText: String) -> Bool {
        if searchText.isEmpty { return true }
        return name.localizedCaseInsensitiveContains(searchText) || hasValidPokemon(for: searchText)
    }

    private func hasValidPokemon(for searchText: String) -> Bool {
        return pokemon.map({ $0.pokemon.name.localizedCaseInsensitiveContains(searchText) }).contains(true)
    }
}

struct TeamPokemon: Identifiable, Equatable, Codable {
    let id = UUID()

    let pokemon: Pokemon

    var nickname: String = ""
    var gender: Gender?
    var ability: Ability?
    var firstMove: Move?
    var secondMove: Move?
    var thirdMove: Move?
    var fourthMove: Move?
    var happiness: Int = 255
    var level: Int = 50
    var shiny = false
    var item: Item?
    var evs: [Int] = [0, 0, 0, 0, 0, 0]
    var nature: Nature?
    var ivs: [Int] = [31, 31, 31, 31, 31, 31]

    var sprite: Image {
        return shiny ? pokemon.shinySprite : pokemon.sprite
    }

    var availableMoves: [Move] {
        return pokemon.moves.filter("versionGroup.id == 18").distinct(by: ["move.id"]).sorted(byKeyPath: "move.identifier").compactMap({ $0.move })
    }

    var totHp: Int {
        guard let baseHp = pokemon.stats.first(where: { $0.stat?.id == 1 })?.baseStat else {
            return 0
        }

        return (((2 * baseHp + ivs[0] + (evs[0] / 4)) * level) / 100) + level + 10
    }

    var totAtk: Int {
        guard let stat = pokemon.stats.first(where: { $0.stat?.id == 2 }) else {
            return 0
        }

        return baseNonHPStat(stat: stat)
    }

    var totDef: Int {
        guard let stat = pokemon.stats.first(where: { $0.stat?.id == 3 }) else {
            return 0
        }

        return baseNonHPStat(stat: stat)
    }

    var totSatk: Int {
        guard let stat = pokemon.stats.first(where: { $0.stat?.id == 4 }) else {
            return 0
        }

        return baseNonHPStat(stat: stat)
    }

    var totSdef: Int {
        guard let stat = pokemon.stats.first(where: { $0.stat?.id == 5 }) else {
            return 0
        }

        return baseNonHPStat(stat: stat)
    }

    var totSpe: Int {
        guard let stat = pokemon.stats.first(where: { $0.stat?.id == 6 }) else {
            return 0
        }

        return baseNonHPStat(stat: stat)
    }

    private func baseNonHPStat(stat: PokemonStat) -> Int {
        let helpfulNature = nature?.increasedStat?.id == stat.stat!.id
        let hinderingNature = nature?.decreasedStat?.id == stat.stat!.id
        let ev = Double(evs[stat.stat!.id - 1])
        let iv = Double(ivs[stat.stat!.id - 1])
        let base = stat.baseStat

        let first = 2 * Double(base) + iv + (ev / 4)
        let second = first * Double(level) / 100
        let third = second + 5
        let natureModifier = 1.0 + (helpfulNature ? 0.1 : 0) - (hinderingNature ? 0.1 : 0)

        return Int(third * natureModifier)
    }

    init(pokemon: Pokemon, nickname: String = "", gender: Gender? = nil, ability: Ability? = nil,
         firstMove: Move? = nil, secondMove: Move? = nil, thirdMove: Move? = nil, fourthMove: Move? = nil,
         level: Int = 50, shiny: Bool = false, item: Item? = nil, evs: [Int] = [0, 0, 0, 0, 0, 0], nature: Nature? = nil,
         ivs: [Int] = [31, 31, 31, 31, 31, 31], happiness: Int = 255) {
        self.pokemon = pokemon; self.nickname = nickname; self.gender = gender; self.ability = ability
        self.firstMove = firstMove; self.secondMove = secondMove; self.thirdMove = thirdMove; self.fourthMove = fourthMove
        self.level = level; self.shiny = shiny; self.item = item; self.evs = evs; self.nature = nature; self.ivs = ivs; self.happiness = happiness
    }

    enum CodingKeys: CodingKey {
        case pokemonName, nickname, genderId, abilityName, firstMoveName, secondMoveName, thirdMoveName, fourthMoveName, level, shiny, itemName, evs, natureName, ivs, happiness
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.pokemon = swiftDexService.pokemon(with: try container.decode(String.self, forKey: .pokemonName))!
        self.nickname = try container.decode(String.self, forKey: .nickname)

        self.gender = swiftDexService.gender(with: try? container.decode(Int.self, forKey: .genderId))
        self.ability = swiftDexService.ability(with: try? container.decode(String.self, forKey: .abilityName))
        self.firstMove = swiftDexService.move(with: try? container.decode(String.self, forKey: .firstMoveName))
        self.secondMove = swiftDexService.move(with: try? container.decode(String.self, forKey: .secondMoveName))
        self.thirdMove = swiftDexService.move(with: try? container.decode(String.self, forKey: .thirdMoveName))
        self.fourthMove = swiftDexService.move(with: try? container.decode(String.self, forKey: .fourthMoveName))
        self.level = try container.decode(Int.self, forKey: .level)
        self.shiny = try container.decode(Bool.self, forKey: .shiny)
        self.item = swiftDexService.item(with: try? container.decode(String.self, forKey: .itemName))
        self.evs = try container.decode([Int].self, forKey: .evs)
        self.ivs = try container.decode([Int].self, forKey: .ivs)
        self.nature = swiftDexService.nature(with: try? container.decode(String.self, forKey: .natureName))
        self.happiness = try container.decode(Int.self, forKey: .happiness)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(pokemon.name, forKey: .pokemonName)
        try container.encode(nickname, forKey: .nickname)

        if let genderId = gender?.id {
            try container.encode(genderId, forKey: .genderId)
        }

        if let abilityName = ability?.name {
            try container.encode(abilityName, forKey: .abilityName)
        }

        if let moveName = firstMove?.name {
            try container.encode(moveName, forKey: .firstMoveName)
        }
        if let moveName = secondMove?.name {
            try container.encode(moveName, forKey: .secondMoveName)
        }
        if let moveName = thirdMove?.name {
            try container.encode(moveName, forKey: .thirdMoveName)
        }
        if let moveName = fourthMove?.name {
            try container.encode(moveName, forKey: .fourthMoveName)
        }

        try container.encode(level, forKey: .level)
        try container.encode(shiny, forKey: .shiny)

        if let itemName = item?.name {
            try container.encode(itemName, forKey: .itemName)
        }

        try container.encode(evs, forKey: .evs)
        try container.encode(ivs, forKey: .ivs)
        try container.encode(happiness, forKey: .happiness)

        if let natureName = nature?.name {
            try container.encode(natureName, forKey: .natureName)
        }
    }
}

let testTeams: [Team] = [
    Team(name: "Team 1", format: swiftDexService.showdownFormats.first, pokemon: [
        TeamPokemon(pokemon: swiftDexService.pokemon(withId: Int.random(in: 1...800))!),
        TeamPokemon(pokemon: swiftDexService.pokemon(withId: Int.random(in: 1...800))!),
        TeamPokemon(pokemon: swiftDexService.pokemon(withId: Int.random(in: 1...800))!),
        TeamPokemon(pokemon: swiftDexService.pokemon(withId: Int.random(in: 1...800))!),
        TeamPokemon(pokemon: swiftDexService.pokemon(withId: Int.random(in: 1...800))!)
    ]),
    Team(name: "Team 2", pokemon: [
        TeamPokemon(pokemon: swiftDexService.pokemon(withId: Int.random(in: 1...800))!),
        TeamPokemon(pokemon: swiftDexService.pokemon(withId: Int.random(in: 1...800))!),
        TeamPokemon(pokemon: swiftDexService.pokemon(withId: Int.random(in: 1...800))!),
        TeamPokemon(pokemon: swiftDexService.pokemon(withId: Int.random(in: 1...800))!),
        TeamPokemon(pokemon: swiftDexService.pokemon(withId: Int.random(in: 1...800))!),
        TeamPokemon(pokemon: swiftDexService.pokemon(withId: Int.random(in: 1...800))!)
    ]),
    Team(name: "Team 3", pokemon: [
        TeamPokemon(pokemon: swiftDexService.pokemon(withId: Int.random(in: 1...800))!),
        TeamPokemon(pokemon: swiftDexService.pokemon(withId: Int.random(in: 1...800))!),
        TeamPokemon(pokemon: swiftDexService.pokemon(withId: Int.random(in: 1...800))!),
        TeamPokemon(pokemon: swiftDexService.pokemon(withId: Int.random(in: 1...800))!),
        TeamPokemon(pokemon: swiftDexService.pokemon(withId: Int.random(in: 1...800))!),
        TeamPokemon(pokemon: swiftDexService.pokemon(withId: Int.random(in: 1...800))!)
    ]),
    Team(name: "Team 4", pokemon: [
        TeamPokemon(pokemon: swiftDexService.pokemon(withId: Int.random(in: 1...800))!),
        TeamPokemon(pokemon: swiftDexService.pokemon(withId: Int.random(in: 1...800))!),
        TeamPokemon(pokemon: swiftDexService.pokemon(withId: Int.random(in: 1...800))!),
        TeamPokemon(pokemon: swiftDexService.pokemon(withId: Int.random(in: 1...800))!),
        TeamPokemon(pokemon: swiftDexService.pokemon(withId: Int.random(in: 1...800))!),
        TeamPokemon(pokemon: swiftDexService.pokemon(withId: Int.random(in: 1...800))!)
    ])
]
