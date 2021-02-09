//
//  TeamBuilderView.swift
//  Pokedex
//
//  Created by TempUser on 2/3/21.
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
    
    @State private var selectedFormat: ShowdownFormat? = nil
    @State private var formatSelectionSourceFrame: CGRect = CGRect.zero
    @State private var showFormatSelectionsView: Bool = false
    
    var body: some View {
        GeometryReader { fullViewProxy in
            ZStack {
                VStack(spacing: 0) {
                    TeamBuilderHeaderView(searchText: $searchText, selectedTeam: $selectedTeam, selectedFormat: $selectedFormat, showFormatSelectionsView: $showFormatSelectionsView, selectedFormatSourceFrame: $formatSelectionSourceFrame).environmentObject(swiftDexService)
                    
                    ScrollView(showsIndicators: false) {
                        LazyVStack(spacing: 15) {
                            ForEach(pokemonShowdownService.teams) { team in
                                if team.isValid(for: searchText) {
                                    TeamSummaryView(team: team).environmentObject(pokemonShowdownService)
                                        .gesture(TapGesture().onEnded() {
                                            selectedTeam = team
                                        })
                                }
                            }
                        }
                        .padding(.vertical)
                    }
                    .padding(.horizontal)
                    .background(Color(.secondarySystemBackground))
                    .fullScreenCover(item: $selectedTeam) { selectedTeam in
                        TeamDetailView(team: selectedTeam).environmentObject(pokemonShowdownService)
                    }
                }
                
                if showFormatSelectionsView {
                    BlankView(bgColor: .black)
                        .opacity(0.5)
                        .onTapGesture {
                            showFormatSelectionsView = false
                        }
                }
                
                GeometryReader { formatSelectionsProxy in
                    FormatSelectionsView(formats: [], showView: $showFormatSelectionsView, selectedFormat: $selectedFormat, sourceFrame: $formatSelectionSourceFrame, searchText: $searchText)
                }
                .edgesIgnoringSafeArea(.top)
            }
        }
        
    }
}

struct TeamBuilderHeaderView: View {
    
    @EnvironmentObject var swiftDexService: SwiftDexService
    
    @Binding var searchText: String
    
    @State private var showVersionSelectionSheet = false
    @State private var showNewTeamActionSheet = false
    
    @Binding var selectedTeam: Team?
    
    @Binding var selectedFormat: ShowdownFormat?
    @Binding var showFormatSelectionsView: Bool
    @Binding var selectedFormatSourceFrame: CGRect
    
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
            
            GeometryReader { bottomBarProxy in
                HStack {
                    GeometryReader { versionSelectionProxy in
                        HStack {
                            ForEach(swiftDexService.selectedVersionGroup.versions) { version in
                                Rectangle()
                                    .foregroundColor(version.color)
                                    .frame(height: 30)
                                    .overlay(
                                        Text(version.names.first(where: {$0.localLanguageId == 9})!.name)
                                            .padding(.horizontal)
                                            .minimumScaleFactor(0.5)
                                            .foregroundColor(.white)
                                    )
                            }
                        }
                        .cornerRadius(8)
                        .onTapGesture {
                            self.showVersionSelectionSheet = true
                        }
                        .sheet(isPresented: $showVersionSelectionSheet, content: {
                            VersionGroupSelectionView(generations: swiftDexService.generations, pokemonFormRestriction: nil, selectedVersionGroup: $swiftDexService.selectedVersionGroup, selectedVersion: $swiftDexService.selectedVersion)
                        })
                    }
                    .frame(width: bottomBarProxy.size.width * 0.65)
                    
                    GeometryReader { formatSelectionProxy in
                        FormatSelectionView(selectedFormat: selectedFormat)
                            .onTapGesture {
                                showFormatSelectionsView = true
                                selectedFormatSourceFrame = formatSelectionProxy.frame(in: .global)
                            }
                    }
                }
            }
            .frame(height: 30)
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(Color(.clear))
    }
}

struct FormatSelectionView: View {
    let selectedFormat: ShowdownFormat?
    
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .foregroundColor(Color(.systemGray5))
            .overlay(
                Text(selectedFormat?.name ?? "Any Format")
                    .padding(.horizontal)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                    .foregroundColor(Color(.secondaryLabel))
            )
    }
}

struct FormatSelectionsView: View {
    let formats: [ShowdownFormat]
    @Binding var showView: Bool
    @Binding var selectedFormat: ShowdownFormat?
    @Binding var sourceFrame: CGRect
    @Binding var searchText: String
    
    var formatsFiltered: [ShowdownFormat] {
        return formats.filter({$0.id != selectedFormat?.id})
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            Group {
                ForEach(formats) { format in
                    FormatSelectionView(selectedFormat: format)
                        .frame(width: sourceFrame.width, height: sourceFrame.height)
                        .offset(y: showView ? CGFloat(formatsFiltered.firstIndex(where: {$0.id == format.id})! * 35) : 0)
                        .onTapGesture {
                            selectedFormat = format
                            searchText = ""
                            showView.toggle()
                        }
                }
                
                if selectedFormat != nil {
                    FormatSelectionView(selectedFormat: nil)
                        .frame(width: sourceFrame.width, height: sourceFrame.height)
                        .offset(y: showView ? CGFloat(formats.count * 35) : 0)
                        .onTapGesture {
                            selectedFormat = nil
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
