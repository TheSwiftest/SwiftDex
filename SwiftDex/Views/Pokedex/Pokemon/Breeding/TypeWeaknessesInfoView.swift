//
//  PokemonTypeWeaknessesInfoView.swift
//  SwiftDex
//
//  Created by Brian Corbin on 4/4/22.
//

import SwiftUI

struct PokemonTypeWeaknessesInfoView: View {
    
    let types: [TypeEffectiveness.TypeData]
    
    private func effectiveness(of damageType: TypeEffectiveness.TypeData) -> TypeEffectiveness.Effectiveness {
        var effectiveness = TypeEffectiveness.Effectiveness.normal

        for type in types {
            effectiveness = effectiveness.combined(with: type.damageEffectiveness(from: damageType))
        }

        return effectiveness
    }
    
    var body: some View {
        VStack {
            PokemonDetailSectionHeader(text: "Type Weaknesses")
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], alignment: .center) {
                ForEach(TypeEffectiveness.TypeData.all(), id: \.rawValue) { type in
                    PokemonTypeWeaknessInfoView(type: type, effectiveness: effectiveness(of: type))
                }
            }
        }
    }
}

struct PokemonTypeWeaknessInfoView: View {
    
    let type: TypeEffectiveness.TypeData
    let effectiveness: TypeEffectiveness.Effectiveness
    
    var body: some View {
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
                    Text(effectiveness.text())
                        .frame(maxWidth: .infinity)
                    Spacer()
                }
            )
    }
}

struct PokemonTypeWeaknessesInfoView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonTypeWeaknessesInfoView(types: [.grass, .poison])
            .previewLayout(.sizeThatFits)
        
        PokemonTypeWeaknessInfoView(type: .grass, effectiveness: .quarter)
            .previewLayout(.sizeThatFits)
    }
}
