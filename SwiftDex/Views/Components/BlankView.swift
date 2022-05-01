//
//  BlankView.swift
//  SwiftDex
//
//  Created by Brian Corbin on 4/14/22.
//

import SwiftUI

struct BlankView: View {
    var bgColor: Color

    var body: some View {
        VStack {
            Spacer()
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(bgColor)
        .edgesIgnoringSafeArea(.all)
    }
}
