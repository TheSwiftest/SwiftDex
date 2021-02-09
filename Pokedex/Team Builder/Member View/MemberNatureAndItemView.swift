//
//  TeamPokemonNatureView.swift
//  Pokedex
//
//  Created by TempUser on 2/8/21.
//

import SwiftUI

struct TeamPokemonNatureSelectionView: View {
    @Environment(\.presentationMode) var presentationMode
    
    let natures: [Nature]
    @Binding var selectedNature: Nature?
    
    @State private var searchText: String = ""
    
    var body: some View {
        VStack {
            TextField("Search Natures", text: $searchText)
                .font(.title)
                .modifier(ClearButton(text: $searchText))
                .padding()
            ScrollView {
                LazyVStack(spacing: 2) {
                    ForEach(natures.filter({searchText.isEmpty ? true : $0.identifier.localizedCaseInsensitiveContains(searchText)})) { nature in
                        NatureView(nature: nature)
                            .onTapGesture {
                                selectedNature = nature
                                presentationMode.wrappedValue.dismiss()
                            }
                    }
                    .padding(.top, 2)
                }
                .padding(.horizontal)
                .background(Color(.secondarySystemBackground))
            }
        }
    }
}

struct NatureView: View {
    let nature: Nature
    
    var body: some View {
        VStack {
            HStack {
                Text(nature.name)
                    .font(.title)
            }
            
            HStack {
                
            }
        }
    }
}

struct TeamPokemonItemSelectionView: View {
    @Environment(\.presentationMode) var presentationMode
    
    let items: [Item]
    @Binding var selectedItem: Item?
    
    @State private var searchText: String = ""
    
    var body: some View {
        VStack {
            TextField("Search Moves", text: $searchText)
                .font(.title)
                .modifier(ClearButton(text: $searchText))
                .padding()
            ScrollView {
                LazyVStack(spacing: 2) {
                    ForEach(items.filter({searchText.isEmpty ? true : $0.identifier.localizedCaseInsensitiveContains(searchText)})) { item in
                        ItemView(item: item, versionGroup: nil)
                            .onTapGesture {
                                self.selectedItem = item
                                presentationMode.wrappedValue.dismiss()
                            }
                    }
                    .padding(.top, 2)
                }

                .background(Color(.secondarySystemBackground))
            }
        }
    }
}

struct TeamPokemonNatureAndItemView: View {
    let availableNatures: [Nature]
    let availableItems: [Item]
    
    @Binding var nature: Nature?
    @Binding var item: Item?
    
    @State private var showItemSelectionView = false
    @State private var showNatureSelectionView = false
    
    private var natureText: String {
        if let nature = nature {
            return nature.name.capitalized
        }
        
        return "Select"
    }
    
    private var itemText: String {
        if let item = item {
            return item.name.capitalized
        }
        
        return "Select"
    }
    
    var body: some View {
        HStack {
            VStack {
                Text(natureText)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .font(.headline)
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)
                    .onTapGesture {
                        showNatureSelectionView = true
                    }
                    .sheet(isPresented: $showNatureSelectionView) {
                        TeamPokemonNatureSelectionView(natures: availableNatures, selectedNature: $nature)
                    }
                    
                Text("Nature")
                    .font(.subheadline)
            }
            
            VStack {
                Text(itemText)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .font(.headline)
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)
                    .onTapGesture {
                        showItemSelectionView = true
                    }
                    .sheet(isPresented: $showItemSelectionView) {
                        TeamPokemonItemSelectionView(items: availableItems, selectedItem: $item)
                    }
                Text("Item")
                    .font(.subheadline)
            }
        }
    }
}
