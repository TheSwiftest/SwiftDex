//
//  MoveLearnMethodsSelectionView.swift
//  SwiftDex
//
//  Created by Brian Corbin on 4/4/22.
//

import SwiftUI

struct MoveLearnMethodsSelectionView: View {
    @Binding var selectedLearnMethod: PokemonMoveMethod
    
    let moveLearnMethods: [PokemonMoveMethod]
    
    var body: some View {
        VStack {
            Picker("Learn Methods", selection: $selectedLearnMethod) {
                ForEach(moveLearnMethods) { method in
                    Text(method.name).tag(method)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            Text(selectedLearnMethod.methodDescription)
                .font(.caption2)
                .foregroundColor(.secondary)
                .minimumScaleFactor(0.5)
                .lineLimit(1)
        }
    }
}

//struct MoveLearnMethodsSelectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        MoveLearnMethodsSelectionView(selectedLearnMethod: .constant(testRealm.object(ofType: PokemonMoveMethod.self, forPrimaryKey: 1)!), moveLearnMethods: Array(testRealm.objects(PokemonMoveMethod.self).filter({$0.id <= 4})))
//            .previewLayout(.sizeThatFits)
//    }
//}
