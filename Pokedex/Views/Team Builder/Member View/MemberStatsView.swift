//
//  TeamPokemonStatsView.swift
//  Pokedex
//
//  Created by BrianCorbin on 2/8/21.
//

import SwiftUI

struct TeamPokemonStatsView: View {
    let pokemonStats: [PokemonStat]
    let nature: Nature?
    let evs: [Int]
    let ivs: [Int]
    let level: Int

    @State private var selectedType: Int = 0

    private var totalHp: Int {
        guard let baseHp = pokemonStats.first(where: { $0.stat?.id == 1 })?.baseStat else {
            return 0
        }

        return (((2 * baseHp + ivs[0] + (evs[0] / 4)) * level) / 100) + level + 10
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

    func total(for pokemonStat: PokemonStat) -> Int {
        if pokemonStat.stat!.id == 1 {
            return totalHp
        }

        return baseNonHPStat(stat: pokemonStat)
    }

    var body: some View {
        VStack(spacing: 10) {
            PokemonDetailSectionHeader(text: "Stats")

            Picker("", selection: $selectedType) {
                Text("Base").tag(1)
                Text("Total").tag(0)
            }
            .pickerStyle(SegmentedPickerStyle())
            .frame(width: 200)

            HStack {
                ForEach(pokemonStats, id: \.self) { pokemonStat in
                    VStack(spacing: 5) {
                        Text(selectedType == 0 ? "\(total(for: pokemonStat))" : "\(pokemonStat.baseStat)")
                            .font(.title3)
                            .fontWeight(.semibold)

                        Text("\(pokemonStat.stat!.identifier.uppercased())")
                            .font(.subheadline)
                            .frame(maxWidth: .infinity)
                    }
                }
            }
        }
    }
}
