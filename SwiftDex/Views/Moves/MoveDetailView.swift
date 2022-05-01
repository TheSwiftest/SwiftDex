//
//  MoveDetailView.swift
//  SwiftDex
//
//  Created by Brian Corbin on 4/5/22.
//

import SwiftUI

struct MoveDetailView: View {
    let move: MoveInfo

    private var moveEffectText: String {
        let effectText = move.effect

        let effectTextParsed = effectText.replacingOccurrences(of: "$effect_chance", with: "\(move.effectChance ?? 0)").replacingOccurrences(of: "\n", with: " ")
        return effectTextParsed
    }

    private var powerText: String {
        guard let power = move.power else {
            return "-"
        }

        return power == 0 ? "-" : "\(power)"
    }

    private var accuracyText: String {
        guard let accuracy = move.accuracy else {
            return "-"
        }

        return accuracy == 0 ? "-" : "\(accuracy)"
    }

    private var ppText: String {
        guard let pp = move.pp else {
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
                            .foregroundColor(move.type.color())
                            .frame(height: 30)
                            .cornerRadius(15)
                            .overlay(
                                HStack {
                                    move.type.icon()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(Color(.white))
                                    Text(move.type.text().uppercased())
                                        .font(.system(size: 18))
                                        .fontWeight(.bold)
                                        .foregroundColor(Color(.white))
                                }
                            )
                        Rectangle()
                            .foregroundColor(move.backgroundColor)
                            .frame(height: 30)
                            .cornerRadius(15)
                            .overlay(
                                HStack {
                                    move.icon
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(move.color)
                                    Text(move.damageClassName.capitalized)
                                        .font(.system(size: 18))
                                        .fontWeight(.bold)
                                        .foregroundColor(Color(.white))
                                }
                            )
                    }

                    Text(move.flavorText)
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
                    Text(move.target)
                        .font(.body)
                }
                .padding(.horizontal)
            }
        }
    }
}


struct MoveDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MoveDetailView(move: tackle)
            .previewLayout(.sizeThatFits)
    }
}
