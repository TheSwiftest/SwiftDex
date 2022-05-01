//
//  PokemonSpeciesInfoView.swift
//  SwiftDex
//
//  Created by Brian Corbin on 4/3/22.
//

import SwiftUI

struct SpeciesInfo {
    let id: Int
    let height: Int
    let weight: Int
    let bodyShape: Int
    let genus: String
}

struct SpeciesInfoView: View {
    let speciesInfo: SpeciesInfo
    let color: Color

    private var heightInMetersText: String {
        return String(format: "%.1f", CGFloat(speciesInfo.height) / 10)
    }

    private var weightInKGText: String {
        return String(format: "%.1f", CGFloat(speciesInfo.weight) / 10)
    }

    var body: some View {
        VStack {
            PokemonDetailSectionHeader(text: "Species Info")
            HStack(alignment: .lastTextBaseline) {
                Group {
                    SpeciesInfoTextView(title: "\(heightInMetersText)m", subtitle: "Height")
                    SpeciesInfoTextView(title: "\(weightInKGText)kg", subtitle: "Weight")
                    Button(action: {
//                        swiftDexService.playCry(for: species)
                    }, label: {
                        SpeciesInfoImageView(image: Image("icon/cry"), imageSize: 18, subtitle: "Cry", color: color)
                    })
                }
                .frame(minWidth: 0, maxWidth: .infinity)
            }
            HStack(alignment: .lastTextBaseline) {
                Group {
                    SpeciesInfoImageView(image: Image("icon/bodyshape/Body\(speciesInfo.bodyShape)"), imageSize: 30, subtitle: "Shape", color: nil)
                    SpeciesInfoImageView(image: Image("icon/footprint/F\(speciesInfo.id)"), imageSize: 30, subtitle: "Footprint", color: color)
                    SpeciesInfoTextView(title: speciesInfo.genus.replacingOccurrences(of: " Pokémon", with: "").capitalized, subtitle: "Genus")
                }
                .frame(minWidth: 0, maxWidth: .infinity)
            }
        }
    }
}

struct SpeciesInfoTextView: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(spacing: 0) {
            Text(title)
                .font(.headline)
            Text(subtitle)
                .font(.caption)
        }
    }
}

struct SpeciesInfoImageView: View {
    let image: Image
    let imageSize: CGFloat
    let subtitle: String
    let color: Color?

    var body: some View {
        VStack(spacing: 0) {
            image
                .resizable()
                .frame(width: imageSize, height: imageSize, alignment: .center)
                .foregroundColor(color)
            Text(subtitle)
                .font(.caption)
        }
    }
}

struct PokemonSpeciesInfoView_Previews: PreviewProvider {
    static var previews: some View {
        SpeciesInfoView(speciesInfo: bulbasaurSpeciesInfo, color: .grass)
            .previewLayout(.sizeThatFits)
    }
}
