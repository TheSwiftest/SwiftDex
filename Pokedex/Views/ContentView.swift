//
//  ContentView.swift
//  Pokedex
//
//  Created by BrianCorbin on 1/24/21.
//

import Kingfisher
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var pokemonShowdownService: PokemonShowdownService
    @EnvironmentObject var swiftDexService: SwiftDexService
    @State private var selectedMove: Move?
    @State private var showSelectedMoveDetail: Bool = false
    @State private var selectedItem: Item?
    @State private var showSelectedItemDetail: Bool = false

    var body: some View {
        ZStack {
            TabView {
                GeometryReader { _ in
                    PokedexView(selectedMove: $selectedMove, showSelectedMoveView: $showSelectedMoveDetail,
                                selectedItem: $selectedItem, showSelectedItemView: $showSelectedItemDetail).environmentObject(swiftDexService)
                }
                .tabItem {
                    Image("tab_icon_dex")
                    Text("SwiftDex")
                }
                TeamBuilderView().environmentObject(swiftDexService).environmentObject(pokemonShowdownService)
                    .tabItem {
                        Image("tab_icon_team_builder")
                        Text("Team Builder")
                    }
                BattleSimulatorView()
                    .tabItem {
                        Image("tab_icon_battle_sim")
                        Text("Battle Sim")
                    }
//                SettingsView().environmentObject(swiftDexService)
//                    .tabItem {
//                        Image(systemName: "gearshape")
//                        Text("Settings")
//                    }
            }
            .zIndex(0)

            if let selectedMove = selectedMove, showSelectedMoveDetail {
                BlankView(bgColor: .black)
                    .opacity(0.5)
                    .onTapGesture {
                        showSelectedMoveDetail = false
                    }
                    .zIndex(1)
                    .edgesIgnoringSafeArea(.bottom)

                GeometryReader { geo in
                    MoveDetailView(move: selectedMove, versionGroup: swiftDexService.selectedVersionGroup)
                        .modifier(ExpandableBottomSheet(containerHeight: geo.size.height, showing: $showSelectedMoveDetail))
                }
                .zIndex(2)
                .edgesIgnoringSafeArea(.bottom)
                .transition(.move(edge: .bottom))
            }

            if let selectedItem = selectedItem, showSelectedItemDetail {
                BlankView(bgColor: .black)
                    .opacity(0.5)
                    .onTapGesture {
                        showSelectedItemDetail = false
                    }
                    .zIndex(1)
                    .edgesIgnoringSafeArea(.bottom)

                GeometryReader { geo in
                    ItemDetailView(item: selectedItem, versionGroup: swiftDexService.selectedVersionGroup)
                        .modifier(ExpandableBottomSheet(containerHeight: geo.size.height, showing: $showSelectedItemDetail))
                }
                .zIndex(2)
                .edgesIgnoringSafeArea(.bottom)
                .transition(.move(edge: .bottom))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(SwiftDexService())
    }
}
