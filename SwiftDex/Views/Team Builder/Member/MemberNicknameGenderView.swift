//
//  MemberNicknameGenderView.swift
//  SwiftDex
//
//  Created by Brian Corbin on 6/22/22.
//

import SwiftUI

struct MemberNicknameGenderView: View {
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
                        Image("icon/gender/male")
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
                        Image("icon/gender/female")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(gender?.id == 1 ? color : Color(.label))
                    })
                }
            }
        }
    }
}

struct MemberNicknameGenderView_Previews: PreviewProvider {
    static var previews: some View {
        MemberNicknameGenderView(genders: [SwiftDexService.male, SwiftDexService.female], nickname: .constant(""), gender: .constant(nil), color: .ice)
            .previewLayout(.sizeThatFits)
    }
}
