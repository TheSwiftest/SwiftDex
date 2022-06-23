//
//  FormsInfoView.swift
//  SwiftDex
//
//  Created by Brian Corbin on 4/8/22.
//

import SwiftUI

struct SpeciesVariationsView: View {
    let variations: [Pokemon]
    
    @Binding var pokemonSelected: Pokemon
    
    var body: some View {
        VStack {
            PokemonDetailSectionHeader(text: "Species Variations")
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], alignment: .center) {
                ForEach(variations) { variation in
                    VStack {
                        Text(variation.name)
                            .minimumScaleFactor(0.5)
                            .lineLimit(1)
                        Rectangle()
                            .foregroundColor(Color(.secondarySystemBackground))
                            .frame(width: 100, height: 100)
                            .overlay(
                                variation.sprite
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 70, height: 70)
                            )
                            .cornerRadius(23)
                            .onTapGesture {
                                pokemonSelected = variation
                            }
                    }
                }
            }
        }
    }
}

struct FormsInfoView_Previews: PreviewProvider {
    static var previews: some View {
        SpeciesVariationsView(variations: SwiftDexService.speciesVariations(for: SwiftDexService.pokemon(withId: 103)!, in: SwiftDexService.versionGroup(withId: 20)!), pokemonSelected: .constant(SwiftDexService.pokemon(withId: 103)!))
            .previewLayout(.sizeThatFits)
    }
}
