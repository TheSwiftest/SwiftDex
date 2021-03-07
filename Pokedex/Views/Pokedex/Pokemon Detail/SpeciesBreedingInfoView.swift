//
//  SpeciesBreedingInfoView.swift
//  Pokedex
//
//  Created by BrianCorbin on 1/26/21.
//

import SwiftUI

struct PokemonBreedingView: View {
    let pokemon: Pokemon

    var body: some View {
        ScrollView {
            VStack {
                Group {
                    SpeciesExtraInfoView(catchRate: pokemon.species!.captureRate, baseHappiness: pokemon.species!.baseHappiness, baseExperience: pokemon.baseExperience,
                                         growthRate: pokemon.species!.growthRate!.name, eggCycles: pokemon.species!.hatchCounter, genderRate: pokemon.species!.genderRate)
                    PokemonEggGroupsView(eggGroups: pokemon.species!.eggGroups.compactMap({$0.eggGroup}), color: pokemon.color)
                    PokemonEVYieldsView(stats: pokemon.stats.compactMap({$0}))
                    PokemonTypeWeaknessesView(types: pokemon.types.compactMap({$0}))
                }
                .padding()
            }
        }
    }
}

struct SpeciesExtraInfoView: View {

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

    var body: some View {
        VStack {
            PokemonDetailSectionHeader(text: "Species Info")
            HStack(alignment: .lastTextBaseline) {
                Group {
                    SpeciesInfoTextView(title: "\(catchRate)", subtitle: "Catch Rate")
                    SpeciesInfoTextView(title: "\(baseHappiness)", subtitle: "Base Happiness")
                    SpeciesInfoTextView(title: "\(baseExperience)", subtitle: "Base Experience")
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            }
            .padding(.top, 20)

            HStack(alignment: .lastTextBaseline) {
                Group {
                    SpeciesInfoTextView(title: "\(growthRate.capitalized)", subtitle: "Growth Rate")
                    SpeciesInfoTextView(title: "\(eggCycles) (\(eggCycles * 255) steps)", subtitle: "Egg Cycles")
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            }
            .padding(.top, 20)

            GeometryReader { geo in
                VStack {
                    HStack(spacing: 0) {
                        if genderRate == -1 {
                            Rectangle()
                                .foregroundColor(Color(.systemGray4))
                                .overlay(
                                    Text("Genderless")
                                        .font(.subheadline)
                                )
                        } else {
                            Rectangle()
                                .frame(width: geo.size.width * malePercentage)
                                .foregroundColor(Color.male)
                                .overlay(
                                    Text("\(String(format: "%.1f", malePercentage * 100))% M")
                                        .font(.subheadline)
                                )
                            Rectangle()
                                .frame(width: geo.size.width * femalePercentage)
                                .foregroundColor(Color.female)
                                .overlay(
                                    Text("\(String(format: "%.1f", femalePercentage * 100))% F")
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

struct PokemonEggGroupsView: View {

    let eggGroups: [EggGroup]
    let color: Color

    var body: some View {
        VStack {
            PokemonDetailSectionHeader(text: "Egg Groups")
            HStack {
                ForEach(eggGroups) { eggGroup in
                    ZStack {
                        Rectangle()
                            .frame(height: 34)
                            .foregroundColor(color)
                            .cornerRadius(8)
                            .overlay(
                                Text(eggGroup.name.capitalized)
                            )
                        HStack {
                            Spacer()
                            Image(systemName: "info.circle")
                                .padding(.trailing, 10)
                        }
                    }

                }
            }
        }
    }
}
