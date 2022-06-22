//
//  FormsInfoView.swift
//  SwiftDex
//
//  Created by Brian Corbin on 4/8/22.
//

import SwiftUI

struct SpeciesVariationsView: View {
    let variations: [Pokemon]
    
    var body: some View {
        VStack {
            if variations.count > 0 {
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
                        }
                    }
                }
            }
        }
    }
}

//struct FormsInfoView_Previews: PreviewProvider {
//    static var previews: some View {
//        SpeciesVariationsView(variations: Array(testRealm.object(ofType: PokemonSpecies.self, forPrimaryKey: 103)!.pokemon))
//            .previewLayout(.sizeThatFits)
//    }
//}
