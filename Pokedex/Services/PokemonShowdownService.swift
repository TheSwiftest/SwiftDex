//
//  PokemonShowdownService.swift
//  Pokedex
//
//  Created by BrianCorbin on 2/6/21.
//

import Foundation
import SwiftUI

class PokemonShowdownService: ObservableObject {
    private let statMap = [
        "HP": 0,
        "Atk": 1,
        "Def": 2,
        "SpA": 3,
        "SpD": 4,
        "Spe": 5
    ]

    @Published var teams: [Team] = []

    init() {
        self.teams = loadTeams()
    }

    func saveTeam(_ team: Team) {
        if let indexOfTeam = teams.firstIndex(where: { $0.id == team.id }) {
            teams.remove(at: indexOfTeam)
            teams.insert(team, at: indexOfTeam)
        } else {
            teams.append(team)
        }

        saveTeams()
    }

    func saveTeams() {
        do {
            let teamsData = try JSONEncoder().encode(teams)
            UserDefaults.standard.setValue(teamsData, forKey: "teams")
        } catch {
            print(error.localizedDescription)
        }
    }

    func deleteTeam(_ team: Team) {
        teams.removeAll(where: { $0.id == team.id })

        do {
            let teamsData = try JSONEncoder().encode(teams)
            UserDefaults.standard.setValue(teamsData, forKey: "teams")
        } catch {
            print(error.localizedDescription)
        }
    }

    private func loadTeams() -> [Team] {
        if let teamsData = UserDefaults.standard.data(forKey: "teams") {
            do {
                return try JSONDecoder().decode([Team].self, from: teamsData)
            } catch {
                print(error.localizedDescription)
            }
        }

        return []
    }

    private func loadTeam(text: String) -> Team? {
        var team = Team(name: "", pokemon: [])

        if let teamPokemon = loadPokemon(from: text) {
            team.pokemon.append(teamPokemon)
        }

        return team
    }

    // MARK: - DO NOT FUCKING TOUCH THIS
    // swiftlint:disable:next function_body_length
    func loadPokemon(from text: String) -> TeamPokemon? {
        var pokemonData = [String: Any]()
        pokemonData["EVs"] = [0, 0, 0, 0, 0, 0]
        pokemonData["IVs"] = [31, 31, 31, 31, 31, 31]

        let lines = text.components(separatedBy: "\n")
        let retardSplit = lines[0].components(separatedBy: "@")

        // This is stupid, but it will produce the same bug as pokemon showdown with nicknames containing "@"
        if retardSplit.count > 1 {
            pokemonData["item"] = retardSplit[retardSplit.count - 1].trimmingCharacters(in: [" "])
        }

        let reversed = retardSplit[0].reversed()
        var curr = ""
        for char in reversed {
            curr = "\(char)" + curr
            if char == "(" && pokemonData["pokemon"] == nil {
                curr = curr.trimmingCharacters(in: [" "])
                if curr.count == 3 {
                    pokemonData["gender"] = curr[curr.index(curr.startIndex, offsetBy: 1)]
                } else {
                    pokemonData["pokemon"] = curr.replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
                }

                curr = ""
            }
        }

        if pokemonData["pokemon"] != nil {
            pokemonData["nickname"] = curr.trimmingCharacters(in: [" "])
        } else {
            pokemonData["pokemon"] = curr.trimmingCharacters(in: [" "])
        }

        var lastIndex = 0

        for (index, line) in lines.enumerated() {
            if index == 0 { continue }
            if line.trimmingCharacters(in: [" "]).starts(with: "-") {
                lastIndex = index
                break
            }

            let pair = line.components(separatedBy: ": ")
            if line.contains("Nature") {
                pokemonData["nature"] = line.replacingOccurrences(of: "Nature", with: "").trimmingCharacters(in: [" "])
            } else if pair[0] == "EVs" || pair[0] == "IVs" {
                var vals = pokemonData[pair[0]] as? [Int] ?? [0, 0, 0, 0, 0, 0]
                let statSplit = pair[1].components(separatedBy: " / ")
                for stat in statSplit {
                    let parts = stat.components(separatedBy: " ")
                    vals[statMap[parts[1]]!] = Int(parts[0])!
                }
                pokemonData[pair[0]] = vals
            } else {
                if pair.count < 2 {
                    continue
                }

                pokemonData[pair[0]] = pair[1].trimmingCharacters(in: [" "])
            }
        }

        var moves: [String?] = [nil, nil, nil, nil]

        for (index, line) in lines.enumerated() {
            if index < lastIndex { continue }
            moves[index % 4] = line.replacingOccurrences(of: "- ", with: "").trimmingCharacters(in: [" "])
        }

        pokemonData["moves"] = moves
        let swiftDexService = SwiftDexService()

        let movesData = pokemonData["moves"] as? [String?] ?? []

        let firstMove = swiftDexService.move(with: movesData[0])
        let secondMove = swiftDexService.move(with: movesData[1])
        let thirdMove = swiftDexService.move(with: movesData[2])
        let fourthMove = swiftDexService.move(with: movesData[3])
        let ability = swiftDexService.ability(with: pokemonData["Ability"] as? String)
        let nature = swiftDexService.nature(with: pokemonData["nature"] as? String)
        let item = swiftDexService.item(with: pokemonData["item"] as? String)
        let shiny = pokemonData["Shiny"] as? String == "Yes"

        let happiness = Int(pokemonData["Happiness"] as? String ?? "255")!
        let level = Int(pokemonData["Level"] as? String ?? "100")!

        guard let pokemon = swiftDexService.pokemon(with: pokemonData["pokemon"] as? String) else {
            return nil
        }

        var gender: Gender?

        if pokemonData["gender"] as? String == "M" {
            gender = swiftDexService.male
        }

        if pokemonData["gender"] as? String == "F" {
            gender = swiftDexService.female
        }

        return TeamPokemon(pokemon: pokemon, nickname: pokemonData["nickname"] as? String ?? "", gender: gender, ability: ability,
                           firstMove: firstMove, secondMove: secondMove, thirdMove: thirdMove, fourthMove: fourthMove,
                           level: level, shiny: shiny, item: item, evs: pokemonData["EVs"] as? [Int] ?? [0, 0, 0, 0, 0, 0], nature: nature,
                           ivs: pokemonData["IVs"] as? [Int] ?? [0, 0, 0, 0, 0, 0], happiness: happiness)
    }

    func importTeamsFromClipboard() {
        var teams: [Team] = []
        guard let clipboardText = UIPasteboard.general.string else {
           return
        }

        let teamsData = clipboardText.trimmingCharacters(in: ["\n"]).components(separatedBy: "\n\n\n")

        for teamData in teamsData {
            var pokemonData = teamData.components(separatedBy: "\n\n")
            var teamHeader = pokemonData.removeFirst()
            teamHeader = teamHeader.trimmingCharacters(in: ["=", " "])
            var components = teamHeader.components(separatedBy: " ")
            let formatIdentifier = components.removeFirst().trimmingCharacters(in: ["[", "]"])
            let name = components.joined(separator: " ")

            let format = swiftDexService.showdownFormats.first(where: { $0.identifier == formatIdentifier })

            var team = Team(name: name, format: format, pokemon: [])
            for data in pokemonData {
                if let teamPokemon = loadPokemon(from: data) {
                    team.pokemon.append(teamPokemon)
                }
            }

            teams.append(team)
        }

        self.teams = teams
        saveTeams()
    }

    func importTeamFromClipboard() -> Team? {
        guard let clipboardText = UIPasteboard.general.string else {
            return nil
        }

        let pokemonData = clipboardText.trimmingCharacters(in: ["\n"]).components(separatedBy: "\n\n")

        var team = Team(name: "", pokemon: [])
        for data in pokemonData {
            if let teamPokemon = loadPokemon(from: data) {
                team.pokemon.append(teamPokemon)
            }
        }

        return team
    }

    func importPokemonFromClipboard() -> TeamPokemon? {
        guard let pokemonData = UIPasteboard.general.string?.trimmingCharacters(in: ["\n"]) else {
            return nil
        }

        return loadPokemon(from: pokemonData)
    }

    func convertPokemonToShowdownFormat(_ pokemon: TeamPokemon) -> String {
        var result = ""

        if !pokemon.nickname.isEmpty {
            result.append("\(pokemon.nickname) ")
        }

        result.append("(\(pokemon.pokemon.showdownName)) ")

        if let gender = pokemon.gender {
            result.append("(\(gender.id == 1 ? "F" : "M")) ")
        }

        if let item = pokemon.item {
            result.append("@ \(item.name)")
        }

        result.append("\n")

        if let ability = pokemon.ability {
            result.append("Ability: \(ability.name)\n")
        }

        result.append("Happiness: \(pokemon.happiness)\n")
        result.append("Level: \(pokemon.level)\n")
        result.append("Shiny: \(pokemon.shiny ? "Yes" : "No")\n")
        result.append("EVs: \(pokemon.evs[0]) HP / \(pokemon.evs[1]) Atk / \(pokemon.evs[2]) Def / \(pokemon.evs[3]) SpA / \(pokemon.evs[4]) SpD / \(pokemon.evs[5]) Spe\n")
        if let nature = pokemon.nature {
            result.append("\(nature.name) Nature\n")
        }

        result.append("IVs: \(pokemon.ivs[0]) HP / \(pokemon.ivs[1]) Atk / \(pokemon.ivs[2]) Def / \(pokemon.ivs[3]) SpA / \(pokemon.ivs[4]) SpD / \(pokemon.ivs[5]) Spe\n")

        if let move = pokemon.firstMove {
            result.append("- \(move.name)\n")
        }
        if let move = pokemon.secondMove {
            result.append("- \(move.name)\n")
        }
        if let move = pokemon.thirdMove {
            result.append("- \(move.name)\n")
        }
        if let move = pokemon.fourthMove {
            result.append("- \(move.name)\n")
        }

        return result.trimmingCharacters(in: ["\n"])
    }

    func exportToClipboard(_ pokemon: TeamPokemon) {
        let res = convertPokemonToShowdownFormat(pokemon)
        UIPasteboard.general.string = res
    }

    func convertTeamToShowdownFormat(_ team: Team) -> String {
        let pokemon = team.pokemon.map({ convertPokemonToShowdownFormat($0) })
        return pokemon.joined(separator: "\n\n")
    }

    func exportToClipboard(_ team: Team) {
        let res = convertTeamToShowdownFormat(team)
        UIPasteboard.general.string = res
    }
}

extension StringProtocol {
    subscript(offset: Int) -> Character { self[index(startIndex, offsetBy: offset)] }
    subscript(range: Range<Int>) -> SubSequence {
        let startIndex = index(self.startIndex, offsetBy: range.lowerBound)
        return self[startIndex..<index(startIndex, offsetBy: range.count)]
    }
    subscript(range: ClosedRange<Int>) -> SubSequence {
        let startIndex = index(self.startIndex, offsetBy: range.lowerBound)
        return self[startIndex..<index(startIndex, offsetBy: range.count)]
    }
    subscript(range: PartialRangeFrom<Int>) -> SubSequence { self[index(startIndex, offsetBy: range.lowerBound)...] }
    subscript(range: PartialRangeThrough<Int>) -> SubSequence { self[...index(startIndex, offsetBy: range.upperBound)] }
    subscript(range: PartialRangeUpTo<Int>) -> SubSequence { self[..<index(startIndex, offsetBy: range.upperBound)] }
}
