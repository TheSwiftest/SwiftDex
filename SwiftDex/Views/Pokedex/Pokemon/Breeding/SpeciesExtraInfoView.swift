//
//  SpeciesExtraInfoView.swift
//  SwiftDex
//
//  Created by Brian Corbin on 4/4/22.
//

import SwiftUI

struct SpeciesExtraInfo {
    let catchRate: Int
    let baseHappiness: Int
    let baseExperience: Int
    let growthRate: String
    let eggCycles: Int
    let genderRate: Int
    
    var malePercentage: CGFloat {
        if genderRate == -1 {
            return 0
        }
        return CGFloat((8 - genderRate)) / 8.0
    }

    var femalePercentage: CGFloat {
        if genderRate == -1 {
            return 0
        }
        return CGFloat(genderRate) / 8.0
    }
}

struct SpeciesExtraInfoView: View {
    let extraInfo: SpeciesExtraInfo

    var body: some View {
        VStack {
            PokemonDetailSectionHeader(text: "Species Info")
            HStack(alignment: .lastTextBaseline) {
                Group {
                    SpeciesInfoTextView(title: "\(extraInfo.catchRate)", subtitle: "Catch Rate")
                    SpeciesInfoTextView(title: "\(extraInfo.baseHappiness)", subtitle: "Base Happiness")
                    SpeciesInfoTextView(title: "\(extraInfo.baseExperience)", subtitle: "Base Experience")
                }
                .frame(minWidth: 0, maxWidth: .infinity)
            }
            .padding(.top, 20)

            HStack(alignment: .lastTextBaseline) {
                Group {
                    SpeciesInfoTextView(title: "\(extraInfo.growthRate.capitalized)", subtitle: "Growth Rate")
                    SpeciesInfoTextView(title: "\(extraInfo.eggCycles) (\(extraInfo.eggCycles * 255) steps)", subtitle: "Egg Cycles")
                }
                .frame(minWidth: 0, maxWidth: .infinity)
            }
            .padding(.top, 20)

            GeometryReader { geo in
                VStack {
                    HStack(spacing: 0) {
                        if extraInfo.genderRate == -1 {
                            Rectangle()
                                .foregroundColor(Color(.systemGray4))
                                .overlay(
                                    Text("Genderless")
                                        .font(.subheadline)
                                )
                        } else {
                            Rectangle()
                                .frame(width: geo.size.width * extraInfo.malePercentage)
                                .foregroundColor(Color.male)
                                .overlay(
                                    Text("\(String(format: "%.1f", extraInfo.malePercentage * 100))% M")
                                        .font(.subheadline)
                                )
                            Rectangle()
                                .frame(width: geo.size.width * extraInfo.femalePercentage)
                                .foregroundColor(Color.female)
                                .overlay(
                                    Text("\(String(format: "%.1f", extraInfo.femalePercentage * 100))% F")
                                        .font(.subheadline)
                                )
                        }
                    }
                    .frame(height: 25)
                    .cornerRadius(15)

                    Text("Gender Ratio")
                        .font(.caption)
                }
            }
            .padding(.top, 20)
        }
    }
}

struct SpeciesExtraInfoView_Previews: PreviewProvider {
    static var previews: some View {
        SpeciesExtraInfoView(extraInfo: testSpeciesExtraInfo)
            .previewLayout(.sizeThatFits)
    }
}
