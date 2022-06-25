//
//  BattleOnlyFormsView.swift
//  SwiftDex
//
//  Created by Brian Corbin on 6/23/22.
//

import SwiftUI

struct BattleOnlyFormsView: View {
    let forms: [PokemonForm]
    
    @Binding var pokemon: Pokemon
    
    var body: some View {
        VStack {
            PokemonDetailSectionHeader(text: "Battle Forms")
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], alignment: .center) {
                ForEach(forms) { form in
                    VStack {
                        Text(form.formIdentifier?.capitalized ?? "Normal")
                            .minimumScaleFactor(0.5)
                            .lineLimit(1)
                        Rectangle()
                            .foregroundColor(Color(.secondarySystemBackground))
                            .frame(width: 100, height: 100)
                            .overlay(
                                form.sprite
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 70, height: 70)
                            )
                            .cornerRadius(23)
                            .onTapGesture {
                                pokemon = form.pokemon!
                            }
                    }
                }
            }
        }
    }
}

struct BattleOnlyFormsView_Previews: PreviewProvider {
    static var previews: some View {
        BattleOnlyFormsView(forms: SwiftDexService.battleOnlyForms(for: SwiftDexService.pokemon(withId: 6)!, in: SwiftDexService.versionGroup(withId: 20)!), pokemon: .constant(SwiftDexService.pokemon(withId: 6)!))
            .previewLayout(.sizeThatFits)
    }
}
