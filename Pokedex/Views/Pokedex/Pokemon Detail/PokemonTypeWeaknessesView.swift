//
//  PokemonTypeWeaknessesView.swift
//  Pokedex
//
//  Created by BrianCorbin on 1/26/21.
//

import SwiftUI

struct PokemonTypeWeaknessesView: View {
    let types: [PokemonType]

    private func effectiveness(of damageType: TypeEffectiveness.TypeData) -> TypeEffectiveness.Effectiveness {
        var effectiveness = TypeEffectiveness.Effectiveness.normal

        for type in types {
            effectiveness = effectiveness.combined(with: type.type!.typeData.damageEffectiveness(from: damageType))
        }

        return effectiveness
    }

    var body: some View {
        VStack {
            PokemonDetailSectionHeader(text: "Type Weaknesses")
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], alignment: .center) {
                ForEach(TypeEffectiveness.TypeData.all(), id: \.rawValue) { type in
                    Rectangle()
                        .foregroundColor(Color(.secondarySystemFill))
                        .frame(width: 80, height: 27)
                        .cornerRadius(13.5)
                        .overlay(
                            HStack {
                                Circle()
                                    .frame(width: 27, height: 27)
                                    .foregroundColor(type.color())
                                    .overlay(
                                        type.icon()
                                            .resizable()
                                            .frame(width: 17, height: 17)
                                            .foregroundColor(Color(.white))
                                    )
                                Text(effectiveness(of: type).text())
                                    .frame(maxWidth: .infinity)
                                Spacer()
                            }
                        )
                }
            }
        }
    }
}
