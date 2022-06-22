//
//  MoveSummaryInfoView.swift
//  SwiftDex
//
//  Created by Brian Corbin on 4/4/22.
//

import SwiftUI

struct MoveSummaryInfoView: View {
    let move: Move
    let subtitle: String?

    private var powerText: String {
        guard let power = move.power else {
            return "-"
        }

        return "\(power)"
    }

    private var accuracyText: String {
        guard let accuracy = move.accuracy else {
            return "-"
        }

        return "\(accuracy)"
    }

    private var ppText: String {
        guard let pp = move.pp else {
            return "-"
        }

        return "\(pp)"
    }

    var body: some View {
        HStack {
            Circle()
                .frame(width: 30, height: 30)
                .foregroundColor(move.type!.color)
                .overlay(
                    move.type!.icon
                        .frame(width: 24, height: 24)
                        .foregroundColor(Color(.white))
                )

            VStack(alignment: .leading) {
                Text(move.name)
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
                .foregroundColor(move.damageClass!.backgroundColor)
                .overlay(
                    move.damageClass!.icon
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(move.damageClass!.color)
                )
        }
        .padding(.horizontal)
        .background(Color(.systemBackground))
    }
}

//struct MoveSummaryInfoView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            MoveSummaryInfoView(move: testRealm.object(ofType: Move.self, forPrimaryKey: 1)!, subtitle: nil)
//            MoveSummaryInfoView(move: testRealm.object(ofType: Move.self, forPrimaryKey: 1)!, subtitle: "Level 1")
//        }
//        .previewLayout(.sizeThatFits)
//    }
//}
