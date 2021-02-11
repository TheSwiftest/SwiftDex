//
//  PokemonStatsView.swift
//  Pokedex
//
//  Created by TempUser on 1/25/21.
//

import SwiftUI

struct PokemonStatsView: View {
    
    @Binding var pokemon: Pokemon
    
    private let maxBaseStats = [255, 190, 250, 194, 250, 200]
        
    var body: some View {
        VStack {
            PokemonDetailSectionHeader(text: "Base Stats")
            ForEach(pokemon.stats.indices) { index in
                PokemonStatView(name: pokemon.stats[index].stat!.identifier, color: pokemon.color, baseStat: pokemon.stats[index].baseStat, max: maxBaseStats[index])
            }
        }
    }
}

struct PokemonStatView: View {
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
                            .animation(.easeIn)
                    }
                )
        }
    }
}
