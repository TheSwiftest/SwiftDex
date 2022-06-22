//
//  MemberLevelHappyShinyView.swift
//  SwiftDex
//
//  Created by Brian Corbin on 6/22/22.
//

import SwiftUI

struct MemberLevelHappyShinyView: View {
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

                Button(action: {
                    if level < 50 {
                        level = 50
                    } else if level < 100 {
                        level = 100
                    } else { level = 0 }
                }, label: {
                    Text("Level")
                        .font(.subheadline)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(Color(.label))
                })
            }

            VStack(spacing: 0) {
                TextField("255", value: $happiness, formatter: NumberFormatter())
                    .font(.title)
                    .foregroundColor(color)
                    .multilineTextAlignment(.center)

                Button(action: {
                    if happiness != 255 {
                        happiness = 255
                    } else {
                        happiness = 0
                    }
                }, label: {
                    Text("Happiness")
                        .font(.subheadline)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(Color(.label))
                })
            }

            VStack(spacing: 0) {
                Button(action: {
                    shiny.toggle()
                }, label: {
                    Image(shiny ? "icon/diamond-filled" : "icon/diamond")
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

struct MemberLevelHappyShinyView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MemberLevelHappyShinyView(level: .constant(50), happiness: .constant(100), color: .ice, shiny: .constant(false))
            MemberLevelHappyShinyView(level: .constant(50), happiness: .constant(100), color: .dragon, shiny: .constant(true))
        }
        .previewLayout(.sizeThatFits)
    }
}
