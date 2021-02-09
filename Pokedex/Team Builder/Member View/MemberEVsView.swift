//
//  TeamPokemonEVsView.swift
//  Pokedex
//
//  Created by TempUser on 2/8/21.
//

import SwiftUI

struct TeamPokemonEVsView: View {
    @Binding var evs: [Int]
    let color: Color
    
    private var evsRemaining: Int {
        return 510 - evs.reduce(0, +)
    }
    
    private func evText(for index: Int) -> String {
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
            
            VStack(spacing: 5) {
                PokemonDetailSectionHeader(text: "EVs")
                Text("Remaining Points: \(evsRemaining)")
                    .font(.caption)
            }
            HStack {
                ForEach(evs.indices) { index in
                    VStack(spacing: 5) {
                        VStack(spacing: 2) {
                            TextField(evs[index] == 0 ? "" : "\(evs[index])", value: $evs[index], formatter: NumberFormatter())
                                .multilineTextAlignment(.center)
                                .font(.title3)
                                .foregroundColor(color)
                            Rectangle()
                                .frame(height: 2)
                                .foregroundColor(color)
                        }
                        
                        Button(evText(for: index)) {
                            if evs[index] != 0 {
                                evs[index] = 0
                            } else {
                                evs[index] = min(252, max(0, evsRemaining))
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
