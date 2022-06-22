//
//  ItemSummaryView.swift
//  SwiftDex
//
//  Created by Brian Corbin on 6/22/22.
//

import SwiftUI

struct ItemSummaryView: View {
    let item: Item
    let versionGroup: VersionGroup?

    var body: some View {
        HStack {
            item.sprite
                .resizable()
                .frame(width: 30, height: 30)

            VStack(alignment: .leading) {
                Text(item.name)
                    .font(.title2)
                    .fontWeight(.semibold)
                Text(item.flavorText(for: versionGroup))
                    .font(.subheadline)
            }
            .padding(.vertical, 10)

            Spacer()
        }
        .padding(.horizontal)
        .background(Color(.systemBackground))
    }
}

struct ItemSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        ItemSummaryView(item: SwiftDexService.item(withId: 1)!, versionGroup: nil)
            .previewLayout(.sizeThatFits)
    }
}
