//
//  TeamPokemonMoveSetView.swift
//  Pokedex
//
//  Created by TempUser on 2/8/21.
//

import SwiftUI

struct TeamPokemonMoveSetView: View {
    let allMoves: [Move]
    let availableMoves: [Move]
    @Binding var firstMove: Move?
    @Binding var secondMove: Move?
    @Binding var thirdMove: Move?
    @Binding var fourthMove: Move?
    
    var body: some View {
        VStack {
            PokemonDetailSectionHeader(text: "Move Set")
            VStack {
                HStack {
                    TeamPokemonMoveView(allMoves: allMoves, availableMoves: availableMoves, move: $firstMove)
                    TeamPokemonMoveView(allMoves: allMoves, availableMoves: availableMoves, move: $secondMove)
                }
                
                HStack {
                    TeamPokemonMoveView(allMoves: allMoves, availableMoves: availableMoves, move: $thirdMove)
                    TeamPokemonMoveView(allMoves: allMoves, availableMoves: availableMoves, move: $fourthMove)
                }
            }
            .cornerRadius(8)
        }
    }
}

struct TeamPokemonMoveView: View {
    let allMoves: [Move]
    let availableMoves: [Move]
    @Binding var move: Move?
    @State private var showMoveSelectionView = false
    
    private var moveText: String {
        if let move = move {
            return move.name.capitalized
        }
        
        return "Select Move"
    }
    
    private var backgroundColor: Color {
        if let move = move {
            return move.type!.color
        }
        
        return Color(.secondarySystemBackground)
    }
    
    var body: some View {
        HStack {
            Text(moveText)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .font(.headline)
                .padding(.horizontal)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
        }
        .frame(height: 45)
        .padding(.horizontal)
        .background(backgroundColor)
        .onTapGesture {
            showMoveSelectionView = true
        }
        .sheet(isPresented: $showMoveSelectionView) {
            TeamPokemonMoveSelectionView(allMoves: allMoves, availableMoves: availableMoves, selectedMove: $move)
        }
    }
}

struct TeamPokemonMoveSelectionView: View {
    @Environment(\.presentationMode) var presentationMode
    
    let allMoves: [Move]
    let availableMoves: [Move]
    @Binding var selectedMove: Move?
    
    @State private var searchText: String = ""
    @State private var showAllMoves: Bool = false
    
    private var moves: [Move] {
        return showAllMoves ? allMoves : availableMoves
    }
    
    var body: some View {
        VStack {
            VStack {
                TextField("Search Moves", text: $searchText)
                    .font(.title)
                    .modifier(ClearButton(text: $searchText))
                Picker("", selection: $showAllMoves) {
                    Text("Pokémon Specific Moves").tag(false)
                    Text("All Moves").tag(true)
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            .padding(.top)
            .padding(.horizontal)
            
            
            ScrollView {
                LazyVStack(spacing: 2) {
                    ForEach(moves.filter({searchText.isEmpty ? true : $0.identifier.localizedCaseInsensitiveContains(searchText)})) { move in
                        MoveView(move: move, pokemonMove: nil, versionGroup: nil)
                            .onTapGesture {
                                selectedMove = move
                                presentationMode.wrappedValue.dismiss()
                            }
                    }
                    .padding(.top, 2)
                }
                .background(Color(.secondarySystemBackground))
            }
        }
    }
}
