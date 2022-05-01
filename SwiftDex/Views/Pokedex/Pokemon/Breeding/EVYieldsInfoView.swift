//
//  EVYieldsInfoView.swift
//  SwiftDex
//
//  Created by Brian Corbin on 4/4/22.
//

import SwiftUI

struct EVYieldsInfoView: View {
    let stats: [PokemonStatInfo]

    var body: some View {
        VStack {
            PokemonDetailSectionHeader(text: "Effort Value Yield")
            HStack {
                ForEach(stats, id: \.identifier) { stat in
                    EVYieldInfoView(stat: stat)
                        .frame(maxWidth: .infinity)
                }
            }
        }
    }
}

struct EVYieldInfoView: View {
    
    let stat: PokemonStatInfo
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18.5)
                .foregroundColor(Color(.secondarySystemFill))
                .frame(width: 37, height: 70)
                .overlay(
                    VStack(spacing: 5) {
                        Circle()
                            .frame(width: 37, height: 37)
                            .foregroundColor(stat.color)
                            .overlay(
                                stat.icon
                                    .resizable()
                                    .frame(width: 34, height: 34)
                                    .foregroundColor(Color(.white))
                            )
                        Text("\(stat.effortValue)")
                            .frame(minHeight: 0, maxHeight: .infinity)
                            .font(.headline)
                        Spacer()
                    }
                )
        }
    }
}

struct EVYieldsInfoView_Previews: PreviewProvider {
    static var previews: some View {
        EVYieldsInfoView(stats: bulbasaurStats)
            .previewLayout(.sizeThatFits)
        
        EVYieldInfoView(stat: PokemonStatInfo(identifier: "hp", name: "HP", value: 60, effortValue: 1))
            .previewLayout(.sizeThatFits)
    }
}
