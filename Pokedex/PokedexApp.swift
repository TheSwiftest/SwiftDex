//
//  PokedexApp.swift
//  Pokedex
//
//  Created by TempUser on 1/24/21.
//

import SwiftUI

@main
struct PokedexApp: App {
    
    let swiftDexService = SwiftDexService()
            
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(swiftDexService)
        }
    }
}
