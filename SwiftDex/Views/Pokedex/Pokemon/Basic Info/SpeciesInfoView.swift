//
//  PokemonSpeciesInfoView.swift
//  SwiftDex
//
//  Created by Brian Corbin on 4/3/22.
//

import SwiftUI

struct SpeciesInfoView: View {
    let id: Int
    let height: Int
    let weight: Int
    let bodyShape: PokemonShape?
    let genus: String
    let color: Color

    private var heightInMetersText: String {
        return String(format: "%.1f", CGFloat(height) / 10)
    }

    private var weightInKGText: String {
        return String(format: "%.1f", CGFloat(weight) / 10)
    }

    var body: some View {
        VStack {
            PokemonDetailSectionHeader(text: "Species Info")
            HStack(alignment: .lastTextBaseline) {
                Group {
                    SpeciesInfoTextView(title: "\(heightInMetersText)m", subtitle: "Height")
                    SpeciesInfoTextView(title: "\(weightInKGText)kg", subtitle: "Weight")
                    Button(action: {
                        SwiftDexService.playCry(forSpeciesId: id)
                    }, label: {
                        SpeciesInfoImageView(image: Image("icon/cry"), imageSize: 18, subtitle: "Cry", color: color)
                    })
                }
                .frame(minWidth: 0, maxWidth: .infinity)
            }
            HStack(alignment: .lastTextBaseline) {
                Group {
                    SpeciesInfoImageView(image: bodyShape?.icon ?? Image("sprite/pokemon/0"), imageSize: 30, subtitle: "Shape", color: nil)
                    SpeciesInfoImageView(image: Image("icon/footprint/F\(id)"), imageSize: 30, subtitle: "Footprint", color: color)
                    SpeciesInfoTextView(title: genus.replacingOccurrences(of: " Pokémon", with: "").capitalized, subtitle: "Genus")
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

//struct PokemonSpeciesInfoView_Previews: PreviewProvider {
//    static var previews: some View {
//        SpeciesInfoView(id: 1, height: 160, weight: 160, bodyShape: testRealm.object(ofType: PokemonShape.self, forPrimaryKey: 1)!, genus: "Seed", color: .grass)
//            .previewLayout(.sizeThatFits)
//    }
//}
