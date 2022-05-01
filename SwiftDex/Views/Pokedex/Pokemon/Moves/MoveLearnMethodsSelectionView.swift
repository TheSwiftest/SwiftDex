//
//  MoveLearnMethodsSelectionView.swift
//  SwiftDex
//
//  Created by Brian Corbin on 4/4/22.
//

import SwiftUI

struct MoveLearnMethod: Identifiable, Hashable {
    let id: Int
    let name: String
    let description: String
}

struct MoveLearnMethodsSelectionView: View {
    
    @Binding var selectedLearnMethod: MoveLearnMethod
    
    let moveLearnMethods: [MoveLearnMethod]
    
    var body: some View {
        VStack {
            Picker("Learn Methods", selection: $selectedLearnMethod) {
                ForEach(moveLearnMethods) { method in
                    Text(method.name).tag(method)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            Text(selectedLearnMethod.description)
                .font(.caption2)
                .foregroundColor(.secondary)
                .minimumScaleFactor(0.5)
                .lineLimit(1)
        }
    }
}

struct MoveLearnMethodsSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        MoveLearnMethodsSelectionView(selectedLearnMethod: .constant(levelUpLearnMoveMethod), moveLearnMethods: testMoveLearnMethods)
            .previewLayout(.sizeThatFits)
    }
}
