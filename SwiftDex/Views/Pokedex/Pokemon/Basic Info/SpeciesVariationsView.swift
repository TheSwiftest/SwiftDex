//
//  FormsInfoView.swift
//  SwiftDex
//
//  Created by Brian Corbin on 4/8/22.
//

import SwiftUI

struct SpeciesVariationsView: View {
    let speciesVariations: [PokemonSummary]
    
    @Binding var selectedPokemon: PokemonSummary?
    
    var body: some View {
        VStack {
            if speciesVariations.count > 1 {
                PokemonDetailSectionHeader(text: "Species Variations")
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], alignment: .center) {
                    ForEach(speciesVariations) { speciesVariation in
                        VStack {
                            Text(speciesVariation.name)
                                .minimumScaleFactor(0.5)
                                .lineLimit(1)
                            Rectangle()
                                .foregroundColor(Color(.secondarySystemBackground))
                                .frame(width: 100, height: 100)
                                .overlay(
                                    speciesVariation.sprite
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 70, height: 70)
                                )
                                .onTapGesture {
                                    selectedPokemon = speciesVariation
                                }
                                .cornerRadius(23)
                        }
                    }
                }
            }
        }
    }
}

struct FormsInfoView_Previews: PreviewProvider {
    static var previews: some View {
        SpeciesVariationsView(speciesVariations: [venusaurSummary, venusaurMegaSummary, venusaurGMaxSummary], selectedPokemon: .constant(venusaurSummary))
            .previewLayout(.sizeThatFits)
    }
}
