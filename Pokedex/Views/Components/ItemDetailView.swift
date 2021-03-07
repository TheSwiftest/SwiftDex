//
//  ItemDetailView.swift
//  Pokedex
//
//  Created by BrianCorbin on 3/7/21.
//

import SwiftUI

struct ItemDetailView: View {
    let item: Item
    let versionGroup: VersionGroup

    private var flingPowerText: String {
        if let flingPower = item.flingPower.value {
            return "\(flingPower)"
        }

        return "-"
    }

    private var flingEffectText: String {
        if let flingEffect = item.flingEffect {
            return flingEffect.identifier.replacingOccurrences(of: "-", with: " ").capitalized
        }

        return "-"
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                    .frame(width: 45)
                VStack {
                    Text(item.name)
                        .font(.title2)
                        .fontWeight(.semibold)
                    Text(item.flavorText(for: versionGroup))
                        .font(.caption)
                }
                item.sprite
                    .resizable()
                    .frame(width: 45, height: 45)
            }
            .padding(.horizontal)
            .padding(.vertical, 5)
            Rectangle()
                .foregroundColor(Color(.systemFill))
                .frame(height: 1)
                .padding(.bottom, 10)
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    SpeciesInfoTextView(title: item.category!.name, subtitle: "Category")
                        .frame(minWidth: 0, maxWidth: .infinity)
                    SpeciesInfoTextView(title: item.category!.pocket!.name, subtitle: "Pocket")
                        .frame(minWidth: 0, maxWidth: .infinity)
                }

                HStack {
                    SpeciesInfoTextView(title: "\(item.cost)", subtitle: "Pokédollars")
                        .frame(minWidth: 0, maxWidth: .infinity)
                    SpeciesInfoTextView(title: flingPowerText, subtitle: "Fling Power")
                        .frame(minWidth: 0, maxWidth: .infinity)
                    SpeciesInfoTextView(title: flingEffectText, subtitle: "Fling Effect")
                        .frame(minWidth: 0, maxWidth: .infinity)
                }

                PokemonDetailSectionHeader(text: "Effect")
                Text(item.effectText)
            }
            .padding(.horizontal)
        }
    }
}
