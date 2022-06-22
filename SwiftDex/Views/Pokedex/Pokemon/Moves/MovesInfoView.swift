//
//  MovesInfoView.swift
//  SwiftDex
//
//  Created by Brian Corbin on 4/4/22.
//

import SwiftUI

struct MovesInfoView: View {
    let moveLearnMethods: [PokemonMoveMethod]
    let pokemonMoves: [PokemonMove]
    
    @State var selectedLearnMethod: PokemonMoveMethod
    @State private var selectedMove: PokemonMove?
    
    init(moveLearnMethods: [PokemonMoveMethod], pokemonMoves: [PokemonMove]) {
        self.moveLearnMethods = moveLearnMethods
        self.pokemonMoves = pokemonMoves
        _selectedLearnMethod = State(initialValue: moveLearnMethods.first!)
    }
    
    private func subtitle(for pokemonMove: PokemonMove) -> String? {
        if pokemonMove.pokemonMoveMethod?.id == 1 {
            return "Level \(pokemonMove.level)"
        }
        
        if pokemonMove.pokemonMoveMethod?.id == 4 {
            return pokemonMove.machineName
        }
        
        return nil
    }
    
    private var movesSortedAndFiltered: [PokemonMove] {
        let pokemonMovesFiltered = pokemonMoves.filter({$0.pokemonMoveMethod == selectedLearnMethod})
        if selectedLearnMethod.id == 1 {
            return pokemonMovesFiltered.sorted(by: {$0.level < $1.level})
        }
        
        if selectedLearnMethod.id == 4 {
            return pokemonMovesFiltered.sorted(by: {$0.machine!.machineNumber < $1.machine!.machineNumber})
        }
        
        return pokemonMovesFiltered
    }
        
    var body: some View {
        VStack(spacing: 0) {
            MoveLearnMethodsSelectionView(selectedLearnMethod: $selectedLearnMethod, moveLearnMethods: moveLearnMethods)
                .padding(.horizontal)
                .padding(.top)
            ScrollView {
                LazyVStack(spacing: 2) {
                    ForEach(movesSortedAndFiltered, id: \.self) { pokemonMove in
                        MoveSummaryInfoView(move: pokemonMove.move!, subtitle: subtitle(for: pokemonMove))
                            .onTapGesture {
                                selectedMove = pokemonMove
                            }
                    }
                }
            }
            .background(Color(.secondarySystemBackground))
        }
        .sheet(item: $selectedMove) { selectedMove in
            MoveDetailView(move: selectedMove.move!, versionGroup: selectedMove.versionGroup!)
        }
    }
}

//struct MovesInfoView_Previews: PreviewProvider {
//    static var previews: some View {
//        MovesInfoView(moveLearnMethods: Array(testRealm.object(ofType: VersionGroup.self, forPrimaryKey: 3)!.pokemonMoveMethods.map({$0.pokemonMoveMethod!})), pokemonMoves: Array(testRealm.object(ofType: Pokemon.self, forPrimaryKey: 1)!.moves.filter({$0.versionGroup?.id == 3})))
//            .previewLayout(.sizeThatFits)
//    }
//}
