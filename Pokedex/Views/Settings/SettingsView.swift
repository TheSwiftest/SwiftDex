//
//  SettingsView.swift
//  Pokedex
//
//  Created by BrianCorbin on 2/3/21.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack {
            Text("Coming Soon!")
                .font(.title)
                .fontWeight(.bold)
                .padding()
            Text("The team is working really hard to bring you more awesome stuff.\n\nWe'll let you know as soon as any new features are ready!")
                .padding()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}