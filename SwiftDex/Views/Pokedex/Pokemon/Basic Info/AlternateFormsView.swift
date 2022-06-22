//
//  AlternateFormsView.swift
//  SwiftDex
//
//  Created by Brian Corbin on 6/21/22.
//

import SwiftUI

struct AlternateFormsView: View {
    let forms: [PokemonForm]
    
    var body: some View {
        VStack {
            if forms.count > 1 {
                PokemonDetailSectionHeader(text: "Forms")
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], alignment: .center) {
                    ForEach(forms) { form in
                        VStack {
                            Text(form.name)
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
                        }
                    }
                }
            }
        }
    }
}

struct AlternateFormsView_Previews: PreviewProvider {
    static var previews: some View {
        AlternateFormsView(forms: Array(testRealm.object(ofType: Pokemon.self, forPrimaryKey: 201)!.forms))
            .previewLayout(.sizeThatFits)
    }
}
