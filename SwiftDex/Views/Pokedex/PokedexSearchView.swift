//
//  PokedexSearchView.swift
//  SwiftDex
//
//  Created by Brian Corbin on 4/8/22.
//

import SwiftUI

struct PokedexSearchView: View {
    
    @Binding var selectedDexCategory: DexCategory
    @Binding var showDexCategorySelectionView: Bool
    @Binding var dexCategorySelectedViewSourceFrame: CGRect
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            GeometryReader { dexCategoryFrame in
                DexCategoryView(dexCategory: $selectedDexCategory, selectedDexCategory: $selectedDexCategory, expanded: .constant(false))
                    .onAppear {
                        dexCategorySelectedViewSourceFrame = dexCategoryFrame.frame(in: .global)
                    }
                    .onTapGesture {
                        showDexCategorySelectionView.toggle()
                    }
            }
            .frame(width: 30, height: 30)

            TextField(selectedDexCategory.rawValue.capitalized, text: $searchText)
                .disableAutocorrection(true)
                .font(.title)
                .modifier(ClearButton(text: $searchText))
        }
        .frame(height: 35)
    }
}

struct PokedexSearchView_Previews: PreviewProvider {
    static var previews: some View {
        PokedexSearchView(selectedDexCategory: .constant(.pokémon), showDexCategorySelectionView: .constant(false), dexCategorySelectedViewSourceFrame: .constant(.zero), searchText: .constant(""))
            .previewLayout(.sizeThatFits)
    }
}
