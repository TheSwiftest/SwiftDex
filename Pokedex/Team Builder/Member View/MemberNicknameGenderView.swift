//
//  TeamPokmemonNicknameGenderView.swift
//  Pokedex
//
//  Created by TempUser on 2/8/21.
//

import SwiftUI

struct TeamPokemonNicknameAndGenderView: View {
    let genders: [Gender]
    @Binding var nickname: String
    @Binding var gender: Gender?
    let color: Color
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 20) {
            VStack(spacing: 5) {
                TextField("Nickname", text: $nickname)
                    .font(.title)
                Rectangle()
                    .frame(height: 2)
                    .foregroundColor(color)
            }
            
            VStack {
                Text("Gender")
                    .font(.headline)
                HStack {
                    Button(action: {
                        if gender?.id == 2 {
                            gender = nil
                        } else {
                            gender = genders[0]
                        }
                    }, label: {
                        Image("gender_male")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(gender?.id == 2 ? color : Color(.label))
                    })
                    
                    Button(action: {
                        if gender?.id == 1 {
                            gender = nil
                        } else {
                            gender = genders[1]
                        }
                    }, label: {
                        Image("gender_female")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(gender?.id == 1 ? color : Color(.label))
                    })
                }
            }
        }
    }
}
