//
//  MovesInfoView.swift
//  SwiftDex
//
//  Created by Brian Corbin on 4/4/22.
//

import SwiftUI

struct PokemonMovesInfo {
    let moveLearnMethods: [MoveLearnMethod]
    let pokemonMoves: [PokemonMoveInfo]
}

struct MovesInfoView: View {
    let info: PokemonMovesInfo
    
    @State private var selectedLearnMethod: MoveLearnMethod
    @State private var selectedMove: MoveInfo?
    
    init(info: PokemonMovesInfo) {
        self.info = info
        _selectedLearnMethod = State(initialValue: info.moveLearnMethods[0])
    }
        
    var body: some View {
        VStack(spacing: 0) {
            MoveLearnMethodsSelectionView(selectedLearnMethod: $selectedLearnMethod, moveLearnMethods: info.moveLearnMethods)
                .padding(.horizontal)
                .padding(.top)
            ScrollView {
                LazyVStack(spacing: 2) {
                    ForEach(info.pokemonMoves.filter({$0.moveLearnInfo.moveLearnMethod == selectedLearnMethod}), id: \.self) { pokemonMove in
                        MoveSummaryInfoView(moveLearnInfo: pokemonMove.moveLearnInfo, moveInfo: pokemonMove.moveInfo)
                            .onTapGesture {
                                selectedMove = pokemonMove.moveInfo
                            }
                    }
                }
            }
            .background(Color(.secondarySystemBackground))
        }
        .sheet(item: $selectedMove) { selectedMove in
            MoveDetailView(move: selectedMove)
        }
    }
}

struct MovesInfoView_Previews: PreviewProvider {
    static var previews: some View {
        MovesInfoView(info: testPokemonMovesInfo)
            .previewLayout(.sizeThatFits)
    }
}
