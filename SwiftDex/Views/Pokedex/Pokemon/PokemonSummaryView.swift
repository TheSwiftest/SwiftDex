//
//  PokemonSummaryView.swift
//  SwiftDex
//
//  Created by Brian Corbin on 4/2/22.
//

import SwiftUI

struct PokemonSummaryView: View {
    let summary: PokemonSummary
    let showVersionView: Bool
    
    @Binding var showVersionSelectionView: Bool
    
    private var pokedexNumberFormatted: String {
        return "#\(String(format: "%03d", summary.pokedexNumber))"
    }
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Text(pokedexNumberFormatted)
                            .font(.title2)
                        Text(summary.name)
                            .font(.title2)
                            .bold()
                            .lineLimit(1)
                        Spacer()
                    }
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color(hex: "D8D8D8"))
                        .padding(.bottom, 15)
                        .padding(.top, 10)
                    HStack(spacing: 15) {
                        ForEach(summary.types, id: \.typeData) { type in
                            PokemonSummaryTypeView(type: type)
                        }
                    }
                }
                
                summary.sprite
                    .resizable()
                    .scaledToFill()
                    .frame(width: 96, height: 96)
                    .cornerRadius(23)
            }
            
            if showVersionView {
                PokemonSummaryVersionView(name: summary.versionName, showVersionSelectionView: $showVersionSelectionView)
            }
        }
        .padding(.leading)
        .padding(.vertical, 6)
        .background(summary.types[0].typeData.color())
        .cornerRadius(4)
        .shadow(radius: 5)
    }
}

struct PokemonSummaryTypeView: View {
    
    let type: PokemonSummary.PokemonType
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color(hex: "D8D8D8"))
                .cornerRadius(4)
                .opacity(0.55)
                .frame(height: 30)
            HStack {
                type.typeData.icon()
                    .frame(width: 25, height: 25)
                    .opacity(0.55)
                Text(type.name.uppercased())
                    .font(.system(.subheadline))
                    .fontWeight(.semibold)
                    .opacity(0.55)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
            }
        }
    }
}

struct PokemonSummaryVersionView: View {
    
    let name: String
    
    @Binding var showVersionSelectionView: Bool
    
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
                            Text("\(name) Version")
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

struct PokemonSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonSummaryView(summary: bulbasaurSummary, showVersionView: false, showVersionSelectionView: .constant(false))
            .previewLayout(.sizeThatFits)
        
        PokemonSummaryView(summary: bulbasaurSummary, showVersionView: true, showVersionSelectionView: .constant(false))
            .previewLayout(.sizeThatFits)
    }
}
