//
//  MoveDetailView.swift
//  Pokedex
//
//  Created by BrianCorbin on 2/3/21.
//

import SwiftUI

struct MoveDetailView: View {
    let move: Move
    let versionGroup: VersionGroup

    private var flavorText: String {
        return move.flavorTexts.first(where: { $0.languageId == 9 && $0.versionGroup!.id == versionGroup.id })?.flavorText.replacingOccurrences(of: "\n", with: " ") ?? "No flavor text for this move"
    }

    private var moveEffectText: String {
        let effectText = move.effect?.effectDescription ?? "No move effect for this move"

        let effectTextParsed = effectText.replacingOccurrences(of: "$effect_chance", with: "\(move.effectChance.value ?? 0)").replacingOccurrences(of: "\n", with: " ")
        return effectTextParsed
    }

    private var powerText: String {
        guard let power = move.power.value else {
            return "-"
        }

        return power == 0 ? "-" : "\(power)"
    }

    private var accuracyText: String {
        guard let accuracy = move.accuracy.value else {
            return "-"
        }

        return accuracy == 0 ? "-" : "\(accuracy)"
    }

    private var ppText: String {
        guard let pp = move.pp.value else {
            return "-"
        }

        return pp == 0 ? "-" : "\(pp)"
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                Text(move.name)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.top)
                    .padding(.bottom, 10)
                Rectangle()
                    .foregroundColor(Color(.systemFill))
                    .frame(height: 1)
                    .padding(.bottom, 10)
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Rectangle()
                            .foregroundColor(move.type!.color)
                            .frame(height: 30)
                            .cornerRadius(15)
                            .overlay(
                                HStack {
                                    move.type!.icon
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(Color(.white))
                                    Text(move.type!.name.uppercased())
                                        .font(.system(size: 18))
                                        .fontWeight(.bold)
                                        .foregroundColor(Color(.white))
                                }
                            )
                        if let damageClass = move.damageClass {
                            Rectangle()
                                .foregroundColor(damageClass.backgroundColor)
                                .frame(height: 30)
                                .cornerRadius(15)
                                .overlay(
                                    HStack {
                                        damageClass.icon
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                            .foregroundColor(damageClass.color)
                                        Text(damageClass.name.uppercased())
                                            .font(.system(size: 18))
                                            .fontWeight(.bold)
                                            .foregroundColor(Color(.white))
                                    }
                                )
                        }
                    }

                    Text(flavorText)
                        .font(.body)

                    PokemonDetailSectionHeader(text: "Stats")
                    HStack {
                        VStack {
                            Text("POW")
                                .font(.title2)
                            Text(powerText)
                                .font(.title2)
                                .bold()
                        }
                        .frame(maxWidth: .infinity)
                        VStack {
                            Text("ACC")
                                .font(.title2)
                            Text(accuracyText)
                                .font(.title2)
                                .bold()
                        }
                        .frame(maxWidth: .infinity)
                        VStack {
                            Text("PP")
                                .font(.title2)
                            Text(ppText)
                                .font(.title2)
                                .bold()
                        }
                        .frame(maxWidth: .infinity)
                        VStack {
                            Text("PRIO")
                                .font(.title2)
                            Text("\(move.priority)")
                                .font(.title2)
                                .bold()
                        }
                        .frame(maxWidth: .infinity)
                    }

                    PokemonDetailSectionHeader(text: "Effect")
                    Text(moveEffectText)
                        .font(.body)

                    PokemonDetailSectionHeader(text: "Target")
                    Text(move.target!.targetDescription)
                        .font(.body)
                }
                .padding(.horizontal)
            }
        }
    }
}
