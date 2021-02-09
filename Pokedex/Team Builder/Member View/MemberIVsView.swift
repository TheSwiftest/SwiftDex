//
//  TeamPokemonIVsView.swift
//  Pokedex
//
//  Created by TempUser on 2/8/21.
//

import SwiftUI

struct TeamPokemonIVsView: View {
    @Binding var ivs: [Int]
    let color: Color
    
    @State private var showIVPresetSelectionSheet: Bool = false
    
    private let presets: [[Int]] = [
        [31,0,31,31,31,31],
        [31,0,31,31,31,0],
        [31,31,31,31,31,31],
        [31,31,31,31,31,0]
    ]
    
    private func ivText(for index: Int) -> String {
        switch index {
        case 0: return "HP"
        case 1: return "ATK"
        case 2: return "DEF"
        case 3: return "SATK"
        case 4: return "SDEF"
        case 5: return "SPE"
        default: return "NA"
        }
    }
    
    var body: some View {
        VStack(spacing: 10) {
            PokemonDetailSectionHeader(text: "IVs")
            
            Button(action: {
                showIVPresetSelectionSheet = true
            }, label: {
                HStack(alignment: .center, spacing: 1) {
                    Group {
                        Text("Presets")
                            .font(.caption)
                        Image(systemName: "info.circle")
                            .font(.system(size: 10))
                    }
                    
                    .foregroundColor(color)
                }
            })
            .actionSheet(isPresented: $showIVPresetSelectionSheet, content: {
                ActionSheet(title: Text("Select A Preset"), message: nil, buttons: [
                    ActionSheet.Button.default(Text("Min Atk")) {ivs = presets[0]},
                    ActionSheet.Button.default(Text("Min Atk & Spe")) {ivs = presets[1]},
                    ActionSheet.Button.default(Text("Max All")) {ivs = presets[2]},
                    ActionSheet.Button.default(Text("Min Spe")) {ivs = presets[3]},
                    ActionSheet.Button.cancel()
                ])
            })
            
            HStack {
                ForEach(ivs.indices) { index in
                    VStack(spacing: 5) {
                        VStack(spacing: 2) {
                            TextField(ivs[index] == 0 ? "" : "\(ivs[index])", value: $ivs[index], formatter: NumberFormatter())
                                .multilineTextAlignment(.center)
                                .font(.title3)
                                .foregroundColor(color)
                            Rectangle()
                                .frame(height: 2)
                                .foregroundColor(color)
                        }
                        
                        Button(ivText(for: index)) {
                            if ivs[index] != 31 {
                                ivs[index] = 31
                            } else {
                                ivs[index] = 0
                            }
                        }
                        .foregroundColor(color)
                        .frame(maxWidth: .infinity)
                    }
                }
            }
        }
    }
}
