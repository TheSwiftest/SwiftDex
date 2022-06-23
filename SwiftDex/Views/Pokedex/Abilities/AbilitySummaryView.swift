//
//  AbilitySummaryView.swift
//  SwiftDex
//
//  Created by Brian Corbin on 6/23/22.
//

import SwiftUI

struct AbilitySummaryView: View {
    let ability: Ability

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(ability.name)
                    .font(.title2)
                    .fontWeight(.semibold)
                Text(ability.shortEffect)
                    .font(.subheadline)
            }
            .padding(.vertical, 10)

            Spacer()
        }
        .padding(.horizontal)
        .background(Color(.systemBackground))
    }
}

struct AbilitySummaryView_Previews: PreviewProvider {
    static var previews: some View {
        AbilitySummaryView(ability: SwiftDexService.ability(withId: 1)!)
            .previewLayout(.sizeThatFits)
    }
}
