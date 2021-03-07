//
//  PokemonEVYieldsView.swift
//  Pokedex
//
//  Created by BrianCorbin on 1/26/21.
//

import SwiftUI

struct PokemonEVYieldsView: View {

    let stats: [PokemonStat]

    var body: some View {
        VStack {
            PokemonDetailSectionHeader(text: "Effort Value Yield")
            HStack {
                ForEach(stats, id: \.self) { pokemonStat in
                    ZStack {
                        RoundedRectangle(cornerRadius: 18.5)
                            .foregroundColor(Color(.secondarySystemFill))
                            .frame(width: 37, height: 70)
                            .overlay(
                                VStack(spacing: 5) {
                                    Circle()
                                        .frame(width: 37, height: 37)
                                        .foregroundColor(pokemonStat.stat!.color)
                                        .overlay(
                                            pokemonStat.stat!.icon
                                                .resizable()
                                                .frame(width: 34, height: 34)
                                                .foregroundColor(Color(.white))
                                        )
                                    Text("\(pokemonStat.effort)")
                                        .frame(minHeight: 0, maxHeight: .infinity)
                                        .font(.headline)
                                    Spacer()
                                }
                            )
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
    }
}
