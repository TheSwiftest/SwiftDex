//
//  DetailSectionView.swift
//  SwiftDex
//
//  Created by Brian Corbin on 4/8/22.
//

import SwiftUI

struct PokemonDetailSectionHeader: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.title2)
            .bold()
    }
}

struct DetailSectionView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonDetailSectionHeader(text: "Hello, World!")
            .previewLayout(.sizeThatFits)
    }
}
