//
//  PokedexView.swift
//  Pokedex
//
//  Created by BrianCorbin on 1/31/21.
//

import Kingfisher
import SwiftUI

enum DexCategory: String, Hashable {
    case pokémon, moves, items, abilities

    func icon() -> Image {
        switch self {
        case .pokémon: return Image("dex_type_pokemon")
        case .moves: return Image("dex_type_moves")
        case .items: return Image("dex_type_items")
        case .abilities: return Image("dex_type_abilities")
        }
    }

    static func all(except: DexCategory? = nil) -> [DexCategory] {
        var included = [DexCategory]()
        if except != .pokémon { included.append(.pokémon) }
        if except != .moves { included.append(.moves) }
        if except != .items { included.append(.items) }
        if except != .abilities { included.append(.abilities) }
        return included
    }
}

struct PokedexView: View {
    @EnvironmentObject var swiftDexService: SwiftDexService

    @Binding var selectedMove: Move?
    @Binding var showSelectedMoveView: Bool
    @Binding var selectedItem: Item?
    @Binding var showSelectedItemView: Bool

    @State private var pokemonDexNumberToShow: PokemonDexNumber?

    @State private var searchText: String = ""

    @State private var selectedDexCategory: DexCategory = .pokémon

    @State private var showDexSelectionViews = false
    @State private var dexCategorySelectedViewSourceFrame = CGRect.zero

    @State private var showVersionSelectionSheet = false

    @State private var pokedexSelectedViewSourceFrame = CGRect.zero
    @State private var showPokedexSelectionView = false

    @State private var selectedPocket: ItemPocket?
    @State private var selectedPocketViewSourceFrame = CGRect.zero
    @State private var showItemPocketSelectionView = false

    @State private var selectedMoveDamageClass: MoveDamageClass?
    @State private var selectedMoveDamageViewSourceFrame = CGRect.zero
    @State private var showMoveDamageClassSelectionsView = false

    func pokemonIsInSearchText(dexNumber: PokemonDexNumber) -> Bool {
        return searchText.isEmpty ? true : dexNumber.pokemon!.name.localizedCaseInsensitiveContains(searchText)
    }

    func moveIsInSearchText(move: Move) -> Bool {
        return searchText.isEmpty ? true : move.name.localizedCaseInsensitiveContains(searchText)
    }

    func itemIsInSearchText(item: Item) -> Bool {
        return searchText.isEmpty ? true : item.name.localizedCaseInsensitiveContains(searchText)
    }

    func isInSearchText(text: String) -> Bool {
        return searchText.isEmpty ? true : text.localizedCaseInsensitiveContains(searchText)
    }

    var body: some View {
        ZStack {
            GeometryReader { fullView in
                VStack(spacing: 0) {
                    VStack {
                        HStack {
                            GeometryReader { dexCategoryFrame in
                                DexCategoryView(dexCategory: $selectedDexCategory, expanded: .constant(false), selectedDexCategory: $selectedDexCategory)
                                    .onAppear {
                                        dexCategorySelectedViewSourceFrame = dexCategoryFrame.frame(in: .global)
                                    }
                                    .onTapGesture {
                                        showDexSelectionViews.toggle()
                                    }
                            }
                            .frame(width: 30, height: 30)

                            TextField(selectedDexCategory.rawValue.capitalized, text: $searchText)
                                .disableAutocorrection(true)
                                .font(.title)
                                .modifier(ClearButton(text: $searchText))
                        }
                        .frame(height: 35)

                        HStack {
                            HStack {
                                ForEach(swiftDexService.selectedVersionGroup.versions) { version in
                                    Rectangle()
                                        .foregroundColor(version.color)
                                        .frame(height: 30)
                                        .overlay(
                                            Text(version.names.first(where: { $0.localLanguageId == 9 })!.name)
                                                .padding(.horizontal)
                                                .minimumScaleFactor(0.5)
                                                .foregroundColor(.white)
                                        )
                                }
                            }
                            .frame(minWidth: fullView.size.width * 0.65)
                            .cornerRadius(8)
                            .onTapGesture {
                                self.showVersionSelectionSheet = true
                            }
                            .sheet(isPresented: $showVersionSelectionSheet, content: {
                                VersionGroupSelectionView(generations: swiftDexService.generations,
                                                          pokemonFormRestriction: nil,
                                                          selectedVersionGroup: $swiftDexService.selectedVersionGroup,
                                                          selectedVersion: $swiftDexService.selectedVersion)
                            })

                            if selectedDexCategory != .abilities {
                                GeometryReader { pokedexSelectionViewGeo in
                                    if selectedDexCategory == .pokémon {
                                        PokedexSelectionView(pokedex: swiftDexService.selectedPokedex)
                                            .onAppear {
                                                pokedexSelectedViewSourceFrame = pokedexSelectionViewGeo.frame(in: .global)
                                            }
                                            .onTapGesture {
                                                showPokedexSelectionView.toggle()
                                            }
                                    }
                                    if selectedDexCategory == .items {
                                        ItemPocketSelectionView(itemPocket: selectedPocket)
                                            .onAppear {
                                                selectedPocketViewSourceFrame = pokedexSelectionViewGeo.frame(in: .global)
                                            }
                                            .onTapGesture {
                                                showItemPocketSelectionView.toggle()
                                            }
                                    }
                                    if selectedDexCategory == .moves {
                                        MoveDamageClassSelectionView(damageClass: selectedMoveDamageClass)
                                            .onAppear {
                                                selectedMoveDamageViewSourceFrame = pokedexSelectionViewGeo.frame(in: .global)
                                            }
                                            .onTapGesture {
                                                showMoveDamageClassSelectionsView.toggle()
                                            }
                                    }
                                }
                                .frame(height: 30)
                                .frame(maxWidth: .infinity)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .background(Color(.clear))

                    ScrollView {
                        if selectedDexCategory == .pokémon {
                            LazyVStack(spacing: 10) {
                                ForEach(swiftDexService.pokemonDexNumbers(matching: searchText)) { speciesDexNumber in
                                    PokemonView(pokemonDexNumber: speciesDexNumber, selectedVersionGroup: swiftDexService.selectedVersionGroup)
                                        .frame(height: 112)
                                        .padding(.horizontal, 10)
                                        .onTapGesture {
                                            self.pokemonDexNumberToShow = speciesDexNumber
                                        }
                                }
                            }
                            .padding(.top, 10)
                            .sheet(item: $pokemonDexNumberToShow) { pokemonDexNumber in
                                PokemonView(pokemonDexNumber: pokemonDexNumber, selectedVersionGroup: swiftDexService.selectedVersionGroup, showingContent: true).environmentObject(swiftDexService)
                            }
                        }

                        if selectedDexCategory == .moves {
                            LazyVStack(spacing: 2) {
                                ForEach(swiftDexService.movesForVersionGroup(of: selectedMoveDamageClass)) { move in
                                    if moveIsInSearchText(move: move) {
                                        MoveView(move: move, pokemonMove: nil, versionGroup: swiftDexService.selectedVersionGroup)
                                            .onTapGesture {
                                                selectedMove = move
                                                showSelectedMoveView = true
                                            }
                                    }
                                }
                            }
                            .padding(.top, 2)
                        }

                        if selectedDexCategory == .items {
                            LazyVStack(spacing: 2) {
                                ForEach(swiftDexService.itemsForCurrentVersionGroup(in: selectedPocket, andOf: nil)) { item in
                                    if isInSearchText(text: item.name) {
                                        ItemView(item: item, versionGroup: swiftDexService.selectedVersionGroup)
                                            .onTapGesture {
                                                selectedItem = item
                                                showSelectedItemView = true
                                            }
                                    }
                                }
                            }
                            .padding(.top, 2)
                        }

                        if selectedDexCategory == .abilities {
                            LazyVStack(spacing: 2) {
                                ForEach(swiftDexService.abilitiesForVersionGroup()) { ability in
                                    if isInSearchText(text: ability.name) {
                                        AbilityView(ability: ability)
                                    }
                                }
                            }
                        }
                    }
                    .background(Color(.secondarySystemBackground))
                }
            }

            if showDexSelectionViews || showPokedexSelectionView || showItemPocketSelectionView || showMoveDamageClassSelectionsView {
                BlankView(bgColor: .black)
                    .opacity(0.5)
                    .onTapGesture {
                        showDexSelectionViews = false
                        showPokedexSelectionView = false
                        showItemPocketSelectionView = false
                        showMoveDamageClassSelectionsView = false
                    }
            }

            GeometryReader { _ in
                DexCategorySelectionView(selectedDexCategory: $selectedDexCategory, showView: $showDexSelectionViews, sourceFrame: $dexCategorySelectedViewSourceFrame, searchText: $searchText)
                VersionGroupPokedexesSelectionView(sourceFrame: $pokedexSelectedViewSourceFrame, showView: $showPokedexSelectionView)
                ItemPocketsSelectionView(itemPocketsOrdered: swiftDexService.itemPockets().compactMap({ $0 }),
                                         showView: $showItemPocketSelectionView,
                                         selectedPocket: $selectedPocket,
                                         sourceFrame: $selectedPocketViewSourceFrame,
                                         searchText: $searchText)
                MoveDamageClassSelectionsView(damageClassesOrdered: swiftDexService.damageClasses().compactMap({ $0 }),
                                              showView: $showMoveDamageClassSelectionsView,
                                              selectedDamageClass: $selectedMoveDamageClass,
                                              sourceFrame: $selectedMoveDamageViewSourceFrame,
                                              searchText: $searchText)
            }
            .edgesIgnoringSafeArea(.top)
        }
    }
}

struct AbilityView: View {
    let ability: Ability

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(ability.name)
                    .font(.title2)
                    .fontWeight(.semibold)
                Text(ability.shortEffect)
                    .font(.subheadline)
            }
            .padding(.vertical, 10)

            Spacer()
        }
        .padding(.horizontal)
        .background(Color(.systemBackground))
    }
}

struct ItemView: View {
    let item: Item
    let versionGroup: VersionGroup?

    var body: some View {
        HStack {
            item.sprite
                .resizable()
                .frame(width: 30, height: 30)

            VStack(alignment: .leading) {
                Text(item.name)
                    .font(.title2)
                    .fontWeight(.semibold)
                Text(item.flavorText(for: versionGroup))
                    .font(.subheadline)
            }
            .padding(.vertical, 10)

            Spacer()
        }
        .padding(.horizontal)
        .background(Color(.systemBackground))
    }
}

struct MoveDamageClassSelectionsView: View {
    let damageClassesOrdered: [MoveDamageClass]
    @Binding var showView: Bool
    @Binding var selectedDamageClass: MoveDamageClass?
    @Binding var sourceFrame: CGRect
    @Binding var searchText: String

    var damageClasses: [MoveDamageClass] {
        return damageClassesOrdered.filter({ $0.id != selectedDamageClass?.id })
    }

    var body: some View {
        ZStack(alignment: .leading) {
            Group {
                ForEach(damageClasses) { damageClass in
                    MoveDamageClassSelectionView(damageClass: damageClass)
                        .frame(width: sourceFrame.width, height: sourceFrame.height)
                        .offset(y: showView ? CGFloat(damageClasses.firstIndex(of: damageClass)! * 35) : 0)
                        .onTapGesture {
                            selectedDamageClass = damageClass
                            searchText = ""
                            showView.toggle()
                        }
                }

                if selectedDamageClass != nil {
                    MoveDamageClassSelectionView(damageClass: nil)
                        .frame(width: sourceFrame.width, height: sourceFrame.height)
                        .offset(y: showView ? CGFloat(damageClasses.count * 35) : 0)
                        .onTapGesture {
                            selectedDamageClass = nil
                            searchText = ""
                            showView.toggle()
                        }
                }
            }
            .opacity(showView ? 1 : 0)
            .shadow(radius: 5)
            .scaleEffect(showView ? 1.3 : 1, anchor: .topTrailing)
            .animation(.default)
        }
        .offset(x: sourceFrame.minX, y: showView ? sourceFrame.maxY + 5 : sourceFrame.minY)
    }
}

struct MoveDamageClassSelectionView: View {
    let damageClass: MoveDamageClass?

    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .foregroundColor(Color(.systemGray5))
            .overlay(
                Text(damageClass?.name.capitalized ?? "All Types")
                    .padding(.horizontal)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                    .foregroundColor(Color(.secondaryLabel))
            )
    }
}

struct ItemPocketSelectionView: View {
    let itemPocket: ItemPocket?

    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .foregroundColor(Color(.systemGray5))
            .overlay(
                Text(itemPocket?.name ?? "All Pockets")
                    .padding(.horizontal)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                    .foregroundColor(Color(.secondaryLabel))
            )
    }
}

struct ItemPocketsSelectionView: View {
    let itemPocketsOrdered: [ItemPocket]
    @Binding var showView: Bool
    @Binding var selectedPocket: ItemPocket?
    @Binding var sourceFrame: CGRect
    @Binding var searchText: String

    var itemPockets: [ItemPocket] {
        return itemPocketsOrdered.filter({ $0.id != selectedPocket?.id })
    }

    var body: some View {
        ZStack(alignment: .leading) {
            Group {
                ForEach(itemPockets) { itemPocket in
                    ItemPocketSelectionView(itemPocket: itemPocket)
                        .frame(width: sourceFrame.width, height: sourceFrame.height)
                        .offset(y: showView ? CGFloat(itemPockets.firstIndex(of: itemPocket)! * 35) : 0)
                        .onTapGesture {
                            selectedPocket = itemPocket
                            searchText = ""
                            showView.toggle()
                        }
                }

                if selectedPocket != nil {
                    ItemPocketSelectionView(itemPocket: nil)
                        .frame(width: sourceFrame.width, height: sourceFrame.height)
                        .offset(y: showView ? CGFloat(itemPockets.count * 35) : 0)
                        .onTapGesture {
                            selectedPocket = nil
                            searchText = ""
                            showView.toggle()
                        }
                }
            }
            .opacity(showView ? 1 : 0)
            .shadow(radius: 5)
            .scaleEffect(showView ? 1.3 : 1, anchor: .topTrailing)
            .animation(.default)
        }
        .offset(x: sourceFrame.minX, y: showView ? sourceFrame.maxY + 5 : sourceFrame.minY)
    }
}

struct PokedexSelectionView: View {
    let pokedex: Pokedex

    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .foregroundColor(Color(.systemGray5))
            .overlay(
                Text(pokedex.name)
                    .padding(.horizontal)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                    .foregroundColor(Color(.secondaryLabel))
            )
    }
}

struct DexCategoryView: View {
    @Binding var dexCategory: DexCategory
    @Binding var expanded: Bool
    @Binding var selectedDexCategory: DexCategory

    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .frame(width: expanded && selectedDexCategory != dexCategory ? 150 : 30, height: 30)
            .foregroundColor(.dexSearchCategory)
            .overlay(
                HStack {
                    dexCategory.icon()
                        .resizable()
                        .frame(width: 15, height: 15)
                        .foregroundColor(.white)
                        .padding(7.5)
                    if expanded && dexCategory != selectedDexCategory {
                        Text(dexCategory.rawValue.capitalized)
                            .foregroundColor(.white)
                        Spacer()
                    }
                }
            )
    }
}

struct DownCarat: ViewModifier {
    func body(content: Content) -> some View {
        HStack(spacing: 5) {
            content
            Image(systemName: "chevron.compact.down")
        }
    }
}

struct ClearButton: ViewModifier {
    @Binding var text: String

    func body(content: Content) -> some View {
        ZStack(alignment: .trailing) {
            content

            if !text.isEmpty {
                Button(action: {
                    self.text = ""
                }, label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 25))
                        .foregroundColor(Color(.secondarySystemFill))
                })
                .padding(.trailing, 8)
            }
        }
    }
}

struct PokedexView_Previews: PreviewProvider {
    static var previews: some View {
        PokedexView(selectedMove: .constant(nil), showSelectedMoveView: .constant(false), selectedItem: .constant(nil), showSelectedItemView: .constant(false)).environmentObject(SwiftDexService())

        PokedexView(selectedMove: .constant(nil), showSelectedMoveView: .constant(false), selectedItem: .constant(nil), showSelectedItemView: .constant(false)).environmentObject(SwiftDexService())
            .previewDevice(PreviewDevice(rawValue: "iPhone 7"))
    }
}

struct DexCategorySelectionView: View {
    @Binding var selectedDexCategory: DexCategory
    @Binding var showView: Bool
    @Binding var sourceFrame: CGRect
    @Binding var searchText: String

    private let dexCategoriesOrdered: [DexCategory] = [.pokémon, .moves, .items, .abilities]

    private func dexCategories() -> [DexCategory] {
        return dexCategoriesOrdered.filter({ $0 != selectedDexCategory })
    }

    var body: some View {
        ZStack(alignment: .leading) {
            ForEach(dexCategories(), id: \.self) { dexCategory in
                DexCategoryView(dexCategory: .constant(dexCategory), expanded: $showView, selectedDexCategory: $selectedDexCategory)
                    .offset(y: showView ? CGFloat(dexCategories().firstIndex(of: dexCategory)! * 35) : 0)
                    .onTapGesture {
                        selectedDexCategory = dexCategory
                        searchText = ""
                        showView.toggle()
                    }
            }
            .opacity(showView ? 1 : 0)
            .shadow(radius: 5)
            .scaleEffect(showView ? 1.4 : 1, anchor: .topLeading)
            .animation(.default)
        }
        .offset(x: sourceFrame.minX, y: showView ? sourceFrame.maxY + 5 : sourceFrame.minY)
    }
}

struct VersionGroupPokedexesSelectionView: View {
    @EnvironmentObject var swiftDexService: SwiftDexService
    @Binding var sourceFrame: CGRect
    @Binding var showView: Bool

    var body: some View {
        ZStack(alignment: .leading) {
            ForEach(swiftDexService.pokedexesForVersionGroup()) { pokedex in
                PokedexSelectionView(pokedex: pokedex)
                    .frame(width: sourceFrame.width, height: sourceFrame.height)
                    .offset(y: showView ? CGFloat(swiftDexService.pokedexesForVersionGroup().firstIndex(of: pokedex)!) * 35 : 0)
                    .onTapGesture {
                        swiftDexService.selectedPokedex = pokedex
                        showView.toggle()
                    }
            }
            .opacity(showView ? 1 : 0)
            .shadow(radius: 5)
            .scaleEffect(showView ? 1.3 : 1, anchor: .topTrailing)
            .animation(.default)
        }
        .offset(x: sourceFrame.minX, y: showView ? sourceFrame.maxY + 10 : sourceFrame.minY)
    }
}
