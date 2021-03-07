//
//  TeamBuilderView.swift
//  Pokedex
//
//  Created by BrianCorbin on 2/3/21.
//

import SwiftUI
import Kingfisher

struct TeamBuilderView_Previews: PreviewProvider {
    static var previews: some View {
        TeamBuilderView().environmentObject(SwiftDexService()).environmentObject(PokemonShowdownService())
    }
}

struct TeamBuilderView: View {
    @EnvironmentObject var swiftDexService: SwiftDexService
    @EnvironmentObject var pokemonShowdownService: PokemonShowdownService

    @State private var searchText: String = ""
    @State private var selectedTeam: Team?

    @State private var selectedGeneration: Generation?
    @State private var generationSelectionSourceFrame: CGRect = CGRect.zero
    @State private var showGenerationSelectionsView: Bool = false

    @State private var selectedCategory: ShowdownCategory?
    @State private var formatSelectionSourceFrame: CGRect = CGRect.zero
    @State private var showFormatSelectionsView: Bool = false

    var teamsFiltered: [Team] {
        var results = pokemonShowdownService.teams

        if let generation = selectedGeneration {
            results = results.filter({$0.format.generation?.id == generation.id})
        }

        if let category = selectedCategory {
            results = results.filter({$0.format.category?.id == category.id})
        }

        results = results.filter({$0.isValid(for: searchText)})

        return results
    }

    var body: some View {
        GeometryReader { _ in
            ZStack {
                VStack(spacing: 0) {
                    TeamBuilderHeaderView(searchText: $searchText,
                                          selectedTeam: $selectedTeam,
                                          selectedCategory: $selectedCategory,
                                          showFormatSelectionsView: $showFormatSelectionsView,
                                          selectedFormatSourceFrame: $formatSelectionSourceFrame,
                                          selectedGeneration: $selectedGeneration,
                                          showGenerationSelectionsView: $showGenerationSelectionsView,
                                          selectedGenerationSourceFrame: $generationSelectionSourceFrame)
                        .environmentObject(swiftDexService).environmentObject(pokemonShowdownService)

                    if pokemonShowdownService.teams.count > 0 {
                        ScrollView(showsIndicators: false) {
                            LazyVStack(spacing: 15) {
                                ForEach(teamsFiltered) { team in
                                    TeamSummaryView(team: team).environmentObject(pokemonShowdownService)
                                        .gesture(TapGesture().onEnded {
                                            selectedTeam = team
                                        })
                                }
                            }
                            .padding(.vertical)
                        }
                        .padding(.horizontal)
                        .background(Color(.secondarySystemBackground))
                    } else {
                        VStack {
                            Spacer()
                            Text("""
                                    It looks like you have no teams yet! \
                                    You can start fresh by creating a new one\n\n\
                                    Or if you're a Pokémon pro feel free to import a backup from Pokémon Showdown! \
                                    Just make sure it's copied to your clipboard.
                                """)
                                .font(.headline)
                                .multilineTextAlignment(.center)
                                .padding(.bottom)
                                .padding(.horizontal)

                            Button(action: {
                                pokemonShowdownService.importTeamsFromClipboard()
                            }, label: {
                                Text("Import Showdown Backup")
                                    .padding(8)
                                    .background(Color(.systemBackground))
                                    .foregroundColor(Color(.secondaryLabel))
                                    .cornerRadius(8)
                            })
                            Spacer()
                        }.background(Color(.secondarySystemBackground))
                    }

                }
                .fullScreenCover(item: $selectedTeam) { selectedTeam in
                    TeamDetailView(team: selectedTeam).environmentObject(pokemonShowdownService)
                }

                if showFormatSelectionsView || showGenerationSelectionsView {
                    BlankView(bgColor: .black)
                        .opacity(0.5)
                        .onTapGesture {
                            showGenerationSelectionsView = false
                            showFormatSelectionsView = false
                        }
                }

                GeometryReader { _ in
                    CategorySelectionsView(categories: swiftDexService.showdownCategories(for: selectedGeneration).compactMap {$0},
                                           showView: $showFormatSelectionsView,
                                           selectedCategory: $selectedCategory,
                                           sourceFrame: $formatSelectionSourceFrame,
                                           searchText: $searchText)
                }
                .edgesIgnoringSafeArea(.top)

                GeometryReader { _ in
                    GenerationSelectionsView(generations: swiftDexService.generations,
                                             showView: $showGenerationSelectionsView,
                                             selectedGeneration: $selectedGeneration,
                                             sourceFrame: $generationSelectionSourceFrame,
                                             searchText: $searchText)
                }
                .edgesIgnoringSafeArea(.top)
            }
        }

    }
}

struct TeamBuilderHeaderView: View {

    @EnvironmentObject var swiftDexService: SwiftDexService
    @EnvironmentObject var pokemonShowdownService: PokemonShowdownService

    @Binding var searchText: String

    @State private var showVersionSelectionSheet = false
    @State private var showNewTeamActionSheet = false

    @Binding var selectedTeam: Team?

    @Binding var selectedCategory: ShowdownCategory?
    @Binding var showFormatSelectionsView: Bool
    @Binding var selectedFormatSourceFrame: CGRect

    @Binding var selectedGeneration: Generation?
    @Binding var showGenerationSelectionsView: Bool
    @Binding var selectedGenerationSourceFrame: CGRect

    var body: some View {
        VStack {
            HStack {
                TextField("Team Search", text: $searchText)
                    .font(.title)
                    .modifier(ClearButton(text: $searchText))
                    .frame(maxWidth: .infinity)

                Button(action: {
                    showNewTeamActionSheet = true
                }, label: {
                    Image(systemName: "plus")
                        .font(.title)
                        .foregroundColor(Color(.label))
                })
                .actionSheet(isPresented: $showNewTeamActionSheet, content: {
                    ActionSheet(title: Text("New Team").font(.title2), message: Text("Import from clipboard supports Pokémon Showdown format"), buttons: [
                        ActionSheet.Button.default(Text("From Scratch")) {
                            selectedTeam = Team()
                        },
                        ActionSheet.Button.default(Text("Import From Clipboard")) {
                            if let newTeam = PokemonShowdownService().importTeamFromClipboard() {
                                selectedTeam = newTeam
                            }
                        },
                        ActionSheet.Button.cancel()
                        ])
                })
            }

            GeometryReader { _ in
                HStack {
                    GeometryReader { generationSelectionProxy in
                        GenerationSelectionView(selectedGeneration: selectedGeneration)
                            .onTapGesture {
                                selectedGenerationSourceFrame = generationSelectionProxy.frame(in: .global)
                                showGenerationSelectionsView = true
                            }
                            .onAppear {
                                selectedGenerationSourceFrame = generationSelectionProxy.frame(in: .global)
                            }
                    }
                    .frame(maxWidth: .infinity)

                    GeometryReader { formatSelectionProxy in
                        CategorySelectionView(selectedCategory: selectedCategory)
                            .onTapGesture {
                                selectedFormatSourceFrame = formatSelectionProxy.frame(in: .global)
                                showFormatSelectionsView = true
                            }
                            .onAppear {
                                selectedFormatSourceFrame = formatSelectionProxy.frame(in: .global)
                            }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .frame(height: 30)
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(Color(.clear))
    }
}

struct GenerationSelectionView: View {
    let selectedGeneration: Generation?

    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .foregroundColor(Color(.systemGray5))
            .overlay(
                Text(selectedGeneration?.name ?? "All Generations")
                    .padding(.horizontal)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                    .foregroundColor(Color(.secondaryLabel))
            )
    }
}

struct GenerationSelectionsView: View {
    let generations: [Generation]
    @Binding var showView: Bool
    @Binding var selectedGeneration: Generation?
    @Binding var sourceFrame: CGRect
    @Binding var searchText: String

    var generationsFiltered: [Generation] {
        return generations.filter({$0.id != selectedGeneration?.id})
    }

    var body: some View {
        ZStack(alignment: .leading) {
            Group {
                ForEach(generationsFiltered) { generation in
                    GenerationSelectionView(selectedGeneration: generation)
                        .frame(width: sourceFrame.width, height: sourceFrame.height)
                        .offset(y: showView ? CGFloat(generationsFiltered.firstIndex(where: {$0.id == generation.id})! * 35) : 0)
                        .onTapGesture {
                            selectedGeneration = generation
                            searchText = ""
                            showView.toggle()
                        }
                }

                if selectedGeneration != nil {
                    GenerationSelectionView(selectedGeneration: nil)
                        .frame(width: sourceFrame.width, height: sourceFrame.height)
                        .offset(y: showView ? CGFloat(generationsFiltered.count * 35) : 0)
                        .onTapGesture {
                            selectedGeneration = nil
                            searchText = ""
                            showView.toggle()
                        }
                }
            }
            .opacity(showView ? 1 : 0)
            .shadow(radius: 5)
            .scaleEffect(showView ? 1.3 : 1, anchor: .topLeading)
            .animation(.default)

        }
        .offset(x: sourceFrame.minX, y: showView ? sourceFrame.maxY + 5 : sourceFrame.minY)
    }
}

struct CategorySelectionView: View {
    let selectedCategory: ShowdownCategory?

    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .foregroundColor(Color(.systemGray5))
            .overlay(
                Text(selectedCategory?.name ?? "All Categories")
                    .padding(.horizontal)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                    .foregroundColor(Color(.secondaryLabel))
            )
    }
}

struct CategorySelectionsView: View {
    let categories: [ShowdownCategory]
    @Binding var showView: Bool
    @Binding var selectedCategory: ShowdownCategory?
    @Binding var sourceFrame: CGRect
    @Binding var searchText: String

    var categoriesFiltered: [ShowdownCategory] {
        return categories.filter({$0.id != selectedCategory?.id})
    }

    var body: some View {
        ZStack(alignment: .leading) {
            Group {
                ForEach(categoriesFiltered) { category in
                    CategorySelectionView(selectedCategory: category)
                        .frame(width: sourceFrame.width, height: sourceFrame.height)
                        .offset(y: showView ? CGFloat(categoriesFiltered.firstIndex(where: {$0.id == category.id})! * 35) : 0)
                        .onTapGesture {
                            selectedCategory = category
                            searchText = ""
                            showView.toggle()
                        }
                }

                if selectedCategory != nil {
                    CategorySelectionView(selectedCategory: nil)
                        .frame(width: sourceFrame.width, height: sourceFrame.height)
                        .offset(y: showView ? CGFloat(categoriesFiltered.count * 35) : 0)
                        .onTapGesture {
                            selectedCategory = nil
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
