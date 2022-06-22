//
//  PokemonStatsInfoView.swift
//  SwiftDex
//
//  Created by Brian Corbin on 4/3/22.
//

import SwiftUI

struct PokemonStatsInfoView: View {
    let stats: [PokemonStat]
    let color: Color

    private let maxBaseStats = [255, 190, 250, 200, 194, 250]

    var body: some View {
        VStack {
            PokemonDetailSectionHeader(text: "Base Stats")
            ForEach(stats.sorted(by: {$0.gameIndex! < $1.gameIndex!}), id: \.self) { pokemonStat in
                PokemonStatInfoView(name: pokemonStat.identifier.uppercased(), color: color, baseStat: pokemonStat.baseStat, max: maxBaseStats[pokemonStat.gameIndex! - 1])
            }
        }
    }
}

struct PokemonStatInfoView: View {
    let name: String
    let color: Color
    let baseStat: Int
    let max: Int

    var body: some View {
        HStack {
            Text(name.uppercased())
                .font(.headline)
                .bold()
                .foregroundColor(color)
                .frame(width: 50, alignment: .leading)
            Text("\(baseStat)")
                .font(.headline)
                .foregroundColor(.secondary)
                .frame(width: 40, alignment: .leading)
            Rectangle()
                .frame(height: 13)
                .cornerRadius(6.5)
                .foregroundColor(Color(.secondarySystemFill))
                .overlay(
                    GeometryReader { geo in
                        Rectangle()
                            .cornerRadius(6.5)
                            .frame(width: geo.size.width * CGFloat(baseStat) / CGFloat(max))
                            .foregroundColor(color)
                    }
                )
        }
    }
}


struct PokemonStatsInfoView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonStatsInfoView(stats: Array(testRealm.object(ofType: Pokemon.self, forPrimaryKey: 1)!.stats),
                             color: .grass)
            .previewLayout(.sizeThatFits)
        PokemonStatInfoView(name: "HP", color: .grass, baseStat: 60, max: 255)
            .previewLayout(.sizeThatFits)
    }
}
