//
//  DexCategorySelectionView.swift
//  SwiftDex
//
//  Created by Brian Corbin on 4/8/22.
//

import SwiftUI

struct DexCategoryView: View {
    @Binding var dexCategory: DexCategory
    @Binding var selectedDexCategory: DexCategory
    @Binding var expanded: Bool
    
    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .frame(width: expanded && selectedDexCategory != dexCategory ? 150 : 30, height: 30)
            .foregroundColor(.dexSearchCategory)
            .overlay(
                HStack {
                    dexCategory.icon()
                        .resizable()
                        .frame(width: 15, height: 15)
                        .foregroundColor(.white)
                        .padding(7.5)
                    if expanded && dexCategory != selectedDexCategory {
                        Text(dexCategory.rawValue.capitalized)
                            .foregroundColor(.white)
                        Spacer()
                    }
                }
            )
    }
}

struct DexCategorySelectionView: View {
    @Binding var selectedDexCategory: DexCategory
    @Binding var showView: Bool
    @Binding var sourceFrame: CGRect
    @Binding var searchText: String

    private let dexCategoriesOrdered: [DexCategory] = [.pokémon, .moves]

    private func dexCategories() -> [DexCategory] {
        return dexCategoriesOrdered.filter({ $0 != selectedDexCategory })
    }

    var body: some View {
        ZStack(alignment: .leading) {
            ForEach(dexCategories(), id: \.self) { dexCategory in
                DexCategoryView(dexCategory: .constant(dexCategory), selectedDexCategory: $selectedDexCategory, expanded: $showView)
                    .offset(y: showView ? CGFloat(dexCategories().firstIndex(of: dexCategory)! * 35) : 0)
                    .onTapGesture {
                        selectedDexCategory = dexCategory
                        searchText = ""
                        showView.toggle()
                    }
            }
            .opacity(showView ? 1 : 0)
            .shadow(radius: 5)
            .scaleEffect(showView ? 1.4 : 1, anchor: .topLeading)
            .animation(.default, value: showView)
        }
        .offset(x: sourceFrame.minX, y: showView ? sourceFrame.maxY + 5 : sourceFrame.minY)
    }
}

struct DexCategorySelectionView_Previews: PreviewProvider {
    static var previews: some View {
        DexCategoryView(dexCategory: .constant(.pokémon), selectedDexCategory: .constant(.pokémon), expanded: .constant(false))
            .previewLayout(.sizeThatFits)
        
        DexCategorySelectionView(selectedDexCategory: .constant(.pokémon), showView: .constant(true), sourceFrame: .constant(.zero), searchText: .constant(""))
    }
}
