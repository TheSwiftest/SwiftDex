//
//  ContentView.swift
//  Pokedex
//
//  Created by TempUser on 1/24/21.
//

import SwiftUI
import Kingfisher

struct ContentView: View {
    
    @EnvironmentObject var swiftDexService: SwiftDexService
    @State private var selectedMove: Move?
    @State private var showSelectedMoveDetail: Bool = false
    
    var body: some View {
        ZStack {
            TabView {
                GeometryReader { fullView in
                    PokedexView(selectedMove: $selectedMove, showSelectedMoveView: $showSelectedMoveDetail).environmentObject(swiftDexService)
                }
                .tabItem {
                    Image("tab_icon_dex")
                    Text("SwiftDex")
                }
                Text("Team Builder")
                    .tabItem {
                        Image("tab_icon_team_builder")
                        Text("Team Builder")
                    }
                Text("Battle Simulator")
                    .tabItem {
                        Image("tab_icon_battle_sim")
                        Text("Battle Sim")
                    }
                SettingsView().environmentObject(swiftDexService)
                    .tabItem {
                        Image(systemName: "gearshape")
                        Text("Settings")
                    }
            }
            .zIndex(0)
            
            if let selectedMove = selectedMove, showSelectedMoveDetail {
                BlankView(bgColor: .black)
                    .opacity(0.5)
                    .onTapGesture {
                        showSelectedMoveDetail = false
                    }
                    .zIndex(1)
                MoveDetailView(move: selectedMove, versionGroup: swiftDexService.selectedVersionGroup)
                    .modifier(ExpandableBottomSheet(isShow: $showSelectedMoveDetail))
                    .transition(.move(edge: .bottom))
                    .zIndex(2)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(SwiftDexService())
    }
}
