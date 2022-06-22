//
//  MemberSummaryView.swift
//  SwiftDex
//
//  Created by Brian Corbin on 6/22/22.
//

import SwiftUI

struct MemberSummaryView: View {
    let pokemon: Pokemon
    let shiny: Bool

    private var nationalPokedexNumber: String {
        return"#\(String(format: "%03d", pokemon.species!.defaultForm.dexNumbers.first(where: { $0.pokedex?.id == 1 })!.pokedexNumber))"
    }

    var body: some View {
        VStack {
            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Text(nationalPokedexNumber)
                            .font(.title2)
                        Text(pokemon.name.capitalized)
                            .font(.title2)
                            .bold()
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                        Spacer()
                    }
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color(hex: "D8D8D8"))
                        .padding(.bottom, 15)
                        .padding(.top, 10)
                    HStack(spacing: 15) {
                        ForEach(pokemon.types, id: \.self) { type in
                            ZStack {
                                Rectangle()
                                    .foregroundColor(Color(hex: "D8D8D8"))
                                    .cornerRadius(4)
                                    .opacity(0.55)
                                    .frame(height: 30)
                                HStack {
                                    type.type!.icon
                                        .frame(width: 25, height: 25)
                                        .opacity(0.55)
                                    Text(type.type!.name.uppercased())
                                        .font(.system(.subheadline))
                                        .fontWeight(.semibold)
                                        .opacity(0.55)
                                }
                            }
                        }
                    }
                }

                (shiny ? pokemon.shinySprite : pokemon.sprite)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 96, height: 96)
                    .cornerRadius(23)
            }
        }
        .padding(.vertical)
        .padding(.leading)
        .background(pokemon.color)
        .cornerRadius(8)
    }
}

struct MemberSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MemberSummaryView(pokemon: SwiftDexService.pokemon(withId: 1)!, shiny: false)
            MemberSummaryView(pokemon: SwiftDexService.pokemon(withId: 1)!, shiny: true)
        }
        .previewLayout(.sizeThatFits)
    }
}
