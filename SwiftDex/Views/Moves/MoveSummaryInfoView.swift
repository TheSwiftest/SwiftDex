//
//  MoveSummaryInfoView.swift
//  SwiftDex
//
//  Created by Brian Corbin on 4/4/22.
//

import SwiftUI

struct PokemonMoveInfo: Hashable {
    let moveLearnInfo: PokemonMoveLearnInfo
    let moveInfo: MoveInfo
}

struct PokemonMoveLearnInfo: Hashable {
    let moveLearnMethod: MoveLearnMethod
    let level: Int
    let order: Int?
}

struct MoveInfo: Identifiable, Hashable {
    let id: Int
    let identifier: String
    let name: String
    let type: TypeEffectiveness.TypeData
    let damageClassIdentifier: String
    let damageClassName: String
    let power: Int?
    let accuracy: Int?
    let pp: Int?
    let priority: Int
    let effect: String
    let effectChance: Int?
    let flavorText: String
    let target: String
    let machineName: String?
    
    var color: Color {
        return Color("color/damage_class/\(damageClassIdentifier)")
    }

    var backgroundColor: Color {
        return Color("color/damage_class/\(damageClassIdentifier)_bg")
    }

    var icon: Image {
        return Image("icon/damage_class/\(damageClassIdentifier)")
    }
}

struct MoveSummaryInfoView: View {
    let moveLearnInfo: PokemonMoveLearnInfo?
    let moveInfo: MoveInfo

    private var subtitle: String? {
        guard let moveLearnInfo = moveLearnInfo else {
            return nil
        }
        
        if moveLearnInfo.moveLearnMethod.id == 1 {
            return "Level \(moveLearnInfo.level)"
        }
        
        if moveLearnInfo.moveLearnMethod.id == 4 {
            return moveInfo.machineName!
        }
        
        return nil
    }

    private var powerText: String {
        guard let power = moveInfo.power else {
            return "-"
        }

        return "\(power)"
    }

    private var accuracyText: String {
        guard let accuracy = moveInfo.accuracy else {
            return "-"
        }

        return "\(accuracy)"
    }

    private var ppText: String {
        guard let pp = moveInfo.pp else {
            return "-"
        }

        return "\(pp)"
    }

    var body: some View {
        HStack {
            Circle()
                .frame(width: 30, height: 30)
                .foregroundColor(moveInfo.type.color())
                .overlay(
                    moveInfo.type.icon()
                        .frame(width: 24, height: 24)
                        .foregroundColor(Color(.white))
                )

            VStack(alignment: .leading) {
                Text(moveInfo.name)
                    .font(.title2)
                    .fontWeight(.semibold)
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.subheadline)
                }
            }
            .padding(.vertical, 10)

            Spacer()

            HStack(spacing: 0) {
                Text(powerText)
                    .frame(width: 45)
                Rectangle()
                    .frame(width: 1)
                    .foregroundColor(Color(.systemBackground))
                Text(accuracyText)
                    .frame(width: 45)
                Rectangle()
                    .frame(width: 1)
                    .foregroundColor(Color(.systemBackground))
                Text(ppText)
                    .frame(width: 45)
            }
            .background(Color(.systemFill))
            .frame(height: 35)
            .cornerRadius(20)

            Circle()
                .frame(width: 30, height: 30)
                .foregroundColor(moveInfo.backgroundColor)
                .overlay(
                    moveInfo.icon
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(moveInfo.color)
                )
        }
        .padding(.horizontal)
        .background(Color(.systemBackground))
    }
}

struct MoveSummaryInfoView_Previews: PreviewProvider {
    static var previews: some View {
        MoveSummaryInfoView(moveLearnInfo: PokemonMoveLearnInfo(moveLearnMethod: testMoveLearnMethods[0], level: 1, order: nil), moveInfo: tackle)
            .previewLayout(.sizeThatFits)
        MoveSummaryInfoView(moveLearnInfo: nil, moveInfo: tackle)
            .previewLayout(.sizeThatFits)
    }
}
