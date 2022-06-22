//
//  EggGroupsInfoView.swift
//  SwiftDex
//
//  Created by Brian Corbin on 4/4/22.
//

import SwiftUI

struct EggGroupsInfoView: View {
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

//struct EggGroupsInfoView_Previews: PreviewProvider {
//    static var previews: some View {
//        EggGroupsInfoView(eggGroups: PokemonBreedingInfo(pokemon: testRealm.object(ofType: Pokemon.self, forPrimaryKey: 1)!).eggGroups, color: .grass)
//            .previewLayout(.sizeThatFits)
//    }
//}
