//
//  TeamPokemonMoveSetView.swift
//  Pokedex
//
//  Created by BrianCorbin on 2/8/21.
//

import SwiftUI

struct TeamPokemonMoveSetView_Previews: PreviewProvider {
    static var previews: some View {
        TeamPokemonMoveSetView(pokemon: SwiftDexService().pokemon(withId: 1)!,
                               firstMove: .constant(nil),
                               secondMove: .constant(nil),
                               thirdMove: .constant(nil),
                               fourthMove: .constant(nil))
            .environmentObject(SwiftDexService())

        TeamPokemonMoveSelectionView(pokemon: SwiftDexService().pokemon(withId: 1)!,
                                     selectedMove: .constant(nil))
            .environmentObject(SwiftDexService())
    }
}

struct TeamPokemonMoveSetView: View {
    @EnvironmentObject var swiftDexService: SwiftDexService

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
                    TeamPokemonMoveView(pokemon: pokemon, move: $firstMove).environmentObject(swiftDexService)
                    TeamPokemonMoveView(pokemon: pokemon, move: $secondMove).environmentObject(swiftDexService)
                }

                HStack {
                    TeamPokemonMoveView(pokemon: pokemon, move: $thirdMove).environmentObject(swiftDexService)
                    TeamPokemonMoveView(pokemon: pokemon, move: $fourthMove).environmentObject(swiftDexService)
                }
            }
            .cornerRadius(8)
        }
    }
}

struct TeamPokemonMoveView: View {
    @EnvironmentObject var swiftDexService: SwiftDexService

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
            TeamPokemonMoveSelectionView(pokemon: pokemon, selectedMove: $move).environmentObject(swiftDexService)
        }
    }
}

struct TeamPokemonMoveSelectionView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var swiftDexService: SwiftDexService

    let pokemon: Pokemon?
    @Binding var selectedMove: Move?

    @State private var searchText: String = ""
    @State private var showAllMoves: Bool = true

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
                    ForEach(swiftDexService.moves(matching: searchText, for: showAllMoves ? nil : pokemon)) { move in
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
