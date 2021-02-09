//
//  TeamPokemonLevelHappyShinyView.swift
//  Pokedex
//
//  Created by TempUser on 2/8/21.
//

import SwiftUI

struct TeamPokemonLevelAndHappinessView: View {
    @Binding var level: Int
    @Binding var happiness: Int
    let color: Color
    @Binding var shiny: Bool
    
    var body: some View {
        HStack(alignment: .lastTextBaseline) {
            VStack(spacing: 0) {
                TextField("100", value: $level, formatter: NumberFormatter())
                    .font(.title)
                    .foregroundColor(color)
                    .multilineTextAlignment(.center)
                
                Text("Level")
                    .font(.subheadline)
                    .frame(maxWidth: .infinity)
            }
            
            VStack(spacing: 0) {
                TextField("255", value: $happiness, formatter: NumberFormatter())
                    .font(.title)
                    .foregroundColor(color)
                    .multilineTextAlignment(.center)
                
                Text("Happiness")
                    .font(.subheadline)
                    .frame(maxWidth: .infinity)
            }
            
            VStack(spacing: 0) {
                Button(action: {
                    shiny.toggle()
                }, label: {
                    Image(shiny ? "diamond-filled" : "diamond")
                        .resizable()
                        .frame(width: 42, height: 42)
                })
                .font(.title)
                .foregroundColor(color)
                
                Text("Shiny")
                    .font(.subheadline)
                    .frame(maxWidth: .infinity)
            }
        }
        
    }
}
