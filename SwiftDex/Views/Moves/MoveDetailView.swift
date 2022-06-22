//
//  MoveDetailView.swift
//  SwiftDex
//
//  Created by Brian Corbin on 4/5/22.
//

import SwiftUI

struct MoveDetailView: View {
    let move: Move
    let versionGroup: VersionGroup

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
                            .foregroundColor(move.type!.color)
                            .frame(height: 30)
                            .cornerRadius(15)
                            .overlay(
                                HStack {
                                    move.type!.icon
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(Color(.white))
                                    Text(move.type!.identifier.uppercased())
                                        .font(.system(size: 18))
                                        .fontWeight(.bold)
                                        .foregroundColor(Color(.white))
                                }
                            )
                        Rectangle()
                            .foregroundColor(move.damageClass!.backgroundColor)
                            .frame(height: 30)
                            .cornerRadius(15)
                            .overlay(
                                HStack {
                                    move.damageClass!.icon
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(move.damageClass!.color)
                                    Text(move.damageClass!.name.capitalized)
                                        .font(.system(size: 18))
                                        .fontWeight(.bold)
                                        .foregroundColor(Color(.white))
                                }
                            )
                    }

                    Text(move.flavorText(for: versionGroup) ?? "No Flavor Text")
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
                    Text(move.shortEffectText)
                        .font(.body)

                    PokemonDetailSectionHeader(text: "Target")
                    Text(move.target!.name)
                        .font(.body)
                }
                .padding(.horizontal)
            }
        }
    }
}


struct MoveDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MoveDetailView(move: testRealm.object(ofType: Move.self, forPrimaryKey: 1)!, versionGroup: testRealm.object(ofType: VersionGroup.self, forPrimaryKey: 3)!)
            .previewLayout(.sizeThatFits)
    }
}
