//
//  PokedexFilterView.swift
//  SwiftDex
//
//  Created by Brian Corbin on 4/8/22.
//

import SwiftUI

struct PokedexFilterView: View {
    let generations: [GenerationInfo]
    let moveDamageClasses: [MoveDamageClassInfo]
    @Binding var selectedVersionGroup: VersionGroupInfo
    @Binding var selectedVersion: VersionInfo
    let selectedPokedex: PokedexInfo
    let selectedMoveDamageClass: MoveDamageClassInfo?
    
    let selectedDexCategory: DexCategory
    
    @State private var showVersionSelectionView: Bool = false
    
    @Binding var pokedexSelectedViewSourceFrame: CGRect
    @Binding var showPokedexSelectionView: Bool
    
    @Binding var moveDamageClassSelectedViewSourceFrame: CGRect
    @Binding var showMoveDamageClassSelectionView: Bool
    
    var body: some View {
        GeometryReader { geo in
            HStack {
                HStack {
                    ForEach(selectedVersionGroup.versions) { version in
                        Rectangle()
                            .foregroundColor(version.color)
                            .overlay(
                                Text(version.name)
                                    .padding(.horizontal)
                                    .minimumScaleFactor(0.5)
                                    .foregroundColor(.white)
                            )
                    }
                }
                .frame(width: geo.size.width * 0.65)
                .cornerRadius(8)
                .onTapGesture {
                    showVersionSelectionView = true
                }
                
                if selectedDexCategory == .pokémon {
                    GeometryReader { pokedexSelectionViewGeo in
                        PokedexSelectedView(name: selectedPokedex.name)
                            .onAppear {
                                pokedexSelectedViewSourceFrame = pokedexSelectionViewGeo.frame(in: .global)
                            }
                            .onTapGesture {
                                showPokedexSelectionView.toggle()
                            }
                    }
                }
                
                if selectedDexCategory == .moves {
                    GeometryReader { moveDamageClassSelectionViewGeo in
                        PokedexSelectedView(name: selectedMoveDamageClass?.name ?? "All Types")
                            .onAppear {
                                moveDamageClassSelectedViewSourceFrame = moveDamageClassSelectionViewGeo.frame(in: .global)
                            }
                            .onTapGesture {
                                showMoveDamageClassSelectionView.toggle()
                            }
                    }
                }
            }
        }
        .frame(height: 30)
        .sheet(isPresented: $showVersionSelectionView) {
            VersionGroupSelectionView(generations: generations, selectedVersionGroup: $selectedVersionGroup, selectedVersion: $selectedVersion)
        }
    }
}

struct PokedexSelectedView: View {
    let name: String
    
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .foregroundColor(Color(.systemGray5))
            .overlay(
                Text(name)
                    .padding(.horizontal)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                    .foregroundColor(Color(.secondaryLabel))
            )
    }
}

struct PokedexSelectionView: View {
    let pokedexes: [PokedexInfo]
    
    @Binding var sourceFrame: CGRect
    @Binding var showView: Bool
    @Binding var selectedPokedex: PokedexInfo
    
    private var filteredPokedexes: [PokedexInfo] {
        return pokedexes.filter({$0.id != selectedPokedex.id})
    }

    var body: some View {
        ZStack(alignment: .leading) {
            ForEach(filteredPokedexes) { pokedex in
                PokedexSelectedView(name: pokedex.name)
                    .frame(width: sourceFrame.width, height: sourceFrame.height)
                    .offset(y: showView ? CGFloat(filteredPokedexes.firstIndex(of: pokedex)!) * 35 : 0)
                    .onTapGesture {
                        selectedPokedex = pokedex
                        showView.toggle()
                    }
            }
            .opacity(showView ? 1 : 0)
            .shadow(radius: 5)
            .scaleEffect(showView ? 1.3 : 1, anchor: .topTrailing)
            .animation(.default, value: showView)
        }
        .offset(x: sourceFrame.minX, y: showView ? sourceFrame.maxY + 10 : sourceFrame.minY)
    }
}

struct MoveDamageClassSelectionView: View {
    let moveDamageClasses: [MoveDamageClassInfo]
    
    @Binding var sourceFrame: CGRect
    @Binding var showView: Bool
    @Binding var selectedMoveDamageClass: MoveDamageClassInfo?
    
    private var filteredMoveDamageClasses: [MoveDamageClassInfo] {
        return moveDamageClasses.filter({$0.id != selectedMoveDamageClass?.id})
    }

    var body: some View {
        ZStack(alignment: .leading) {
            Group {
                ForEach(filteredMoveDamageClasses) { moveDamageClass in
                    PokedexSelectedView(name: moveDamageClass.name)
                        .frame(width: sourceFrame.width, height: sourceFrame.height)
                        .offset(y: showView ? CGFloat(filteredMoveDamageClasses.firstIndex(of: moveDamageClass)!) * 35 : 0)
                        .onTapGesture {
                            selectedMoveDamageClass = moveDamageClass
                            showView.toggle()
                        }
                }
                
                if selectedMoveDamageClass != nil {
                    PokedexSelectedView(name: "All Types")
                        .frame(width: sourceFrame.width, height: sourceFrame.height)
                        .offset(y: showView ? CGFloat(filteredMoveDamageClasses.count * 35) : 0)
                        .onTapGesture {
                            selectedMoveDamageClass = nil
                            showView.toggle()
                        }
                }
            }
            .opacity(showView ? 1 : 0)
            .shadow(radius: 5)
            .scaleEffect(showView ? 1.3 : 1, anchor: .topTrailing)
            .animation(.default, value: showView)
        }
        .offset(x: sourceFrame.minX, y: showView ? sourceFrame.maxY + 10 : sourceFrame.minY)
    }
}

struct VersionGroupSelectionView: View {
    let generations: [GenerationInfo]

    @Binding var selectedVersionGroup: VersionGroupInfo
    @Binding var selectedVersion: VersionInfo

    var body: some View {
        ScrollView {
            VStack {
                Text("Select A Version")
                    .font(.title2)
                ForEach(generations) { generation in
                    GenerationVersionsSelectionView(generation: generation, selectedVersionGroup: $selectedVersionGroup, selectedVersion: $selectedVersion)
                }
            }
            .padding()
        }
    }
}

struct GenerationVersionsSelectionView: View {
    @Environment(\.presentationMode) var presentationMode

    let generation: GenerationInfo

    @Binding var selectedVersionGroup: VersionGroupInfo
    @Binding var selectedVersion: VersionInfo

    var body: some View {
        VStack {
            Text(generation.name)
            ForEach(generation.versionGroups) { versionGroup in
                HStack {
                    ForEach(versionGroup.versions) { version in
                        Rectangle()
                            .frame(height: 30)
                            .foregroundColor(version.color)
                            .overlay(
                                Text(version.name)
                                    .font(.headline)
                                    .foregroundColor(.white)
                            )
                            .onTapGesture {
                                selectedVersion = version
                                selectedVersionGroup = versionGroup
                                presentationMode.wrappedValue.dismiss()
                            }
                    }
                }
                .cornerRadius(15)
            }
        }
    }
}


struct PokedexFilterView_Previews: PreviewProvider {
    static var previews: some View {
        PokedexFilterView(generations: testGenerations, moveDamageClasses: testMDCs, selectedVersionGroup: .constant(redBlueVG), selectedVersion: .constant(redVersion), selectedPokedex: kantoDex, selectedMoveDamageClass: nil, selectedDexCategory: .pokémon, pokedexSelectedViewSourceFrame: .constant(.zero), showPokedexSelectionView: .constant(false), moveDamageClassSelectedViewSourceFrame: .constant(.zero), showMoveDamageClassSelectionView: .constant(false))
            .previewLayout(.sizeThatFits)
    }
}
