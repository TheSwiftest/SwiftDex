//
//  MemberMoveSetView.swift
//  SwiftDex
//
//  Created by Brian Corbin on 6/22/22.
//

import SwiftUI

struct MemberMoveSetView: View {
    let pokemon: Pokemon
    @Binding var firstMove: Move?
    @Binding var secondMove: Move?
    @Binding var thirdMove: Move?
    @Binding var fourthMove: Move?

    var body: some View {
        VStack {
            PokemonDetailSectionHeader(text: "Move Set")
            VStack {
                HStack {
                    MemberMoveView(pokemon: pokemon, move: $firstMove)
                    MemberMoveView(pokemon: pokemon, move: $secondMove)
                }

                HStack {
                    MemberMoveView(pokemon: pokemon, move: $thirdMove)
                    MemberMoveView(pokemon: pokemon, move: $fourthMove)
                }
            }
            .cornerRadius(8)
        }
    }
}

struct MemberMoveView: View {
    let pokemon: Pokemon?
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
            MemberMoveSelectionView(pokemon: pokemon, selectedMove: $move)
        }
    }
}

struct MemberMoveSelectionView: View {
    @Environment(\.presentationMode) var presentationMode

    let pokemon: Pokemon?
    @Binding var selectedMove: Move?

    @State private var searchText: String = ""
    @State private var showAllMoves = true

    var body: some View {
        VStack {
            VStack {
                TextField("Search Moves", text: $searchText)
                    .font(.title)
                    .modifier(ClearButton(text: $searchText))
                Picker("", selection: $showAllMoves) {
                    if pokemon != nil {
                        Text("Pokémon Specific Moves").tag(false)
                    }
                    Text("All Moves").tag(true)
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            .padding(.top)
            .padding(.horizontal)

            ScrollView {
                LazyVStack(spacing: 2) {
                    ForEach(SwiftDexService.moves(matching: searchText, for: showAllMoves ? nil : pokemon)) { move in
                        MoveSummaryInfoView(move: move, subtitle: nil)
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

struct MemberMoveSetView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MemberMoveSetView(pokemon: SwiftDexService.pokemon(withId: 1)!, firstMove: .constant(nil), secondMove: .constant(nil), thirdMove: .constant(nil), fourthMove: .constant(nil))
            MemberMoveView(pokemon: SwiftDexService.pokemon(withId: 1), move: .constant(nil))
        }
        .previewLayout(.sizeThatFits)
        
        MemberMoveSelectionView(pokemon: SwiftDexService.pokemon(withId: 1)!, selectedMove: .constant(nil))
    }
}