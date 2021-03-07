//
//  TeamPokemonNatureView.swift
//  Pokedex
//
//  Created by BrianCorbin on 2/8/21.
//

import SwiftUI

struct MemberNatureView_Previews: PreviewProvider {
    static var previews: some View {
        NatureView(nature: SwiftDexService().nature(with: "Bold")!)
        TeamPokemonNatureSelectionView(natures: SwiftDexService().natures.compactMap({$0}), selectedNature: .constant(nil))
    }
}

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
                }
                .padding(.top, 2)
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
                Spacer()
            }

            HStack(spacing: 15) {
                if nature.increasedStat != nature.decreasedStat {
                    if let stat = nature.increasedStat {
                        NatureStatFlavorView(increased: true, identifier: stat.identifier.uppercased())
                    }

                    if let stat = nature.decreasedStat {
                        NatureStatFlavorView(increased: false, identifier: stat.identifier.uppercased())
                    }

                    if let flavor = nature.likesFlavor {
                        NatureStatFlavorView(increased: true, identifier: flavor.identifier.capitalized)
                    }

                    if let flavor = nature.hatesFlavor {
                        NatureStatFlavorView(increased: false, identifier: flavor.identifier.capitalized)
                    }
                } else {
                    Text("Neutral Flavor")
                }

                Spacer()
            }
        }
        .padding()
        .background(Color(.systemBackground))
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

struct NatureStatFlavorView: View {

    let increased: Bool
    let identifier: String

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "arrow.\(increased ? "up" : "down")")
                .font(.subheadline)
                .foregroundColor(Color(increased ? .systemRed : .systemBlue))
            Text(identifier)
                .font(.subheadline)
                .foregroundColor(Color(increased ? .systemRed : .systemBlue))
        }
    }
}
