//
//  PokemonCardView.swift
//  Pokedex
//
//  Created by TempUser on 1/24/21.
//

import SwiftUI
import Kingfisher

struct PokemonSummaryView: View {
        
    let pokemonDexNumber: PokemonDexNumber
    @Binding var selectedPokemon: Pokemon
    @Binding var selectedForm: PokemonForm
    @Binding var showingContent: Bool
    @Binding var showVersionSelectionView: Bool
    @Binding var selectedVersion: Version
    
    private var species: PokemonSpecies {
        return pokemonDexNumber.species!
    }
    
    private var types: [Type] {
        return selectedPokemon.types.sorted(byKeyPath: "slot", ascending: true).compactMap({$0.type})
    }
    
    private var pokedexNumber: String {
        return "#\(String(format: "%03d", pokemonDexNumber.pokedexNumber))"
    }
    
    private var name: String {
        let speciesName = species.names.first(where: {$0.localLanguageId == 9})?.name ?? "No Name Available"
        let pokemonFormName = selectedForm.names.first(where: {$0.localLanguageId == 9})?.pokemonName
        
        if let pokemonFormName = pokemonFormName, !pokemonFormName.isEmpty {
            return pokemonFormName
        }
        
        return speciesName
    }
    
    private var color: Color {
        return selectedPokemon.types.first(where: {$0.slot == 1})?.type?.color ?? .fire
    }
        
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(color)
                .cornerRadius(4)
                .shadow(radius: 5)
            
            VStack {
                HStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Text(pokedexNumber)
                                .font(.title2)
                            Text(name)
                                .font(.title2)
                                .bold()
                            Spacer()
                        }
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(Color(hex: "D8D8D8"))
                            .padding(.bottom, 15)
                            .padding(.top, 10)
                        HStack(spacing: 15) {
                            ForEach(types, id:\.self) { type in
                                ZStack {
                                    Rectangle()
                                        .foregroundColor(Color(hex: "D8D8D8"))
                                        .cornerRadius(4)
                                        .opacity(0.55)
                                        .frame(height: 30)
                                    HStack {
                                        type.icon
                                            .frame(width: 25, height: 25)
                                            .opacity(0.55)
                                        Text(type.names.first(where: {$0.localLanguageId == 9})!.name.uppercased())
                                            .font(.system(.subheadline))
                                            .fontWeight(.semibold)
                                            .opacity(0.55)
                                    }
                                }
                            }
                        }
                        
                    }
                    
                    KFImage(URL(string: selectedPokemon.spriteImageLink))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 96, height: 96)
                        .cornerRadius(23)
                }
                
                if showingContent {
                    PokemonSummaryAdditionInfo(showVersionSelectionView: $showVersionSelectionView, selectedPokemon: $selectedPokemon, selectedVersion: $selectedVersion)
                }
            }
            .padding(.leading)
        }
    }
}

struct PokemonSummaryAdditionInfo: View {
    
    @Binding var showVersionSelectionView: Bool
    @Binding var selectedPokemon: Pokemon
    @Binding var selectedVersion: Version
    
    var body: some View {
        HStack {
            Rectangle()
                .foregroundColor(Color(hex: "D8D8D8"))
                .cornerRadius(4)
                .opacity(0.55)
                .frame(height: 30)
                .overlay(
                    HStack(spacing: 5) {
                        Group {
                            Text("\(selectedVersion.names.first(where: {$0.localLanguageId == 9})!.name) Version")
                                .fontWeight(.semibold)
                            Image(systemName: "chevron.compact.down")
                        }
                        .font(.system(.subheadline))
                        .opacity(0.55)
                    }
                )
                .onTapGesture {
                    showVersionSelectionView = true
                }
        }
        .padding(.trailing)
    }
}
