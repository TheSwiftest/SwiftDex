//
//  PokemonStatsInfoView.swift
//  SwiftDex
//
//  Created by Brian Corbin on 4/3/22.
//

import SwiftUI

struct PokemonStatInfo {
    let identifier: String
    let name: String
    let value: Int
    let effortValue: Int
    
    var icon: Image {
        return Image("icon/ev/\(identifier)")
    }

    var color: Color {
        return Color("color/ev/\(identifier)")
    }
}

struct PokemonStatsInfoView: View {
    let stats: [PokemonStatInfo]
    let color: Color

    private let maxBaseStats = [255, 190, 250, 194, 250, 200]

    var body: some View {
        VStack {
            PokemonDetailSectionHeader(text: "Base Stats")
            ForEach(stats.indices, id: \.self) { index in
                PokemonStatInfoView(name: stats[index].name, color: color, baseStat: stats[index].value, max: maxBaseStats[index])
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
        PokemonStatsInfoView(stats: bulbasaurStats,
                             color: .grass)
            .previewLayout(.sizeThatFits)
        PokemonStatInfoView(name: "HP", color: .grass, baseStat: 60, max: 255)
            .previewLayout(.sizeThatFits)
    }
}
