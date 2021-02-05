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
    @State private var selectedItem: Item?
    @State private var showSelectedItemDetail: Bool = false
    
    var body: some View {
        ZStack {
            TabView {
                GeometryReader { fullView in
                    PokedexView(selectedMove: $selectedMove, showSelectedMoveView: $showSelectedMoveDetail, selectedItem: $selectedItem, showSelectedItemView: $showSelectedItemDetail).environmentObject(swiftDexService)
                }
                .tabItem {
                    Image("tab_icon_dex")
                    Text("SwiftDex")
                }
                TeamBuilderView()
                    .tabItem {
                        Image("tab_icon_team_builder")
                        Text("Team Builder")
                    }
                BattleSimulatorView()
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

struct ItemDetailView: View {
    let item: Item
    let versionGroup: VersionGroup
    
    private var flingPowerText: String {
        if let flingPower = item.flingPower.value {
            return "\(flingPower)"
        }
        
        return "-"
    }
    
    private var flingEffectText: String {
        if let flingEffect = item.flingEffect {
            return flingEffect.identifier.replacingOccurrences(of: "-", with: " ").capitalized
        }
        
        return "-"
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                    .frame(width: 45)
                VStack {
                    Text(item.name)
                        .font(.title2)
                        .fontWeight(.semibold)
                    Text(item.flavorText(for: versionGroup))
                        .font(.caption)
                }
                KFImage(item.imageURL)
                    .resizable()
                    .frame(width: 45, height: 45)
            }
            .padding(.horizontal)
            .padding(.vertical, 5)
            Rectangle()
                .foregroundColor(Color(.systemFill))
                .frame(height: 1)
                .padding(.bottom, 10)
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    SpeciesInfoTextView(title: item.category!.name, subtitle: "Category")
                        .frame(minWidth: 0, maxWidth: .infinity)
                    SpeciesInfoTextView(title: item.category!.pocket!.name, subtitle: "Pocket")
                        .frame(minWidth: 0, maxWidth: .infinity)
                }
                
                HStack {
                    SpeciesInfoTextView(title: "\(item.cost)", subtitle: "Pokédollars")
                        .frame(minWidth: 0, maxWidth: .infinity)
                    SpeciesInfoTextView(title: flingPowerText, subtitle: "Fling Power")
                        .frame(minWidth: 0, maxWidth: .infinity)
                    SpeciesInfoTextView(title: flingEffectText, subtitle: "Fling Effect")
                        .frame(minWidth: 0, maxWidth: .infinity)
                }
                
                PokemonDetailSectionHeader(text: "Effect")
                Text(item.effectText)
            }
            .padding(.horizontal)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(SwiftDexService())
    }
}
