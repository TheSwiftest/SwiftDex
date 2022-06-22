//
//  PokedexFilterView.swift
//  SwiftDex
//
//  Created by Brian Corbin on 4/8/22.
//

import SwiftUI

struct PokedexFilterView: View {
    let generations: [Generation]
    let moveDamageClasses: [MoveDamageClass]
    @Binding var selectedVersionGroup: VersionGroup
    @Binding var selectedVersion: Version
    let selectedPokedex: Pokedex?
    let selectedMoveDamageClass: MoveDamageClass?
    
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
                        PokedexSelectedView(name: selectedPokedex?.name ?? "National")
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
    let pokedexes: [Pokedex]
    
    @Binding var sourceFrame: CGRect
    @Binding var showView: Bool
    @Binding var selectedPokedex: Pokedex?
    
    private var filteredPokedexes: [Pokedex] {
        return pokedexes.filter({$0 != selectedPokedex})
    }

    var body: some View {
        ZStack(alignment: .leading) {
            Group {
                ForEach(filteredPokedexes) { pokedex in
                    PokedexSelectedView(name: pokedex.name)
                        .frame(width: sourceFrame.width, height: sourceFrame.height)
                        .offset(y: showView ? CGFloat(filteredPokedexes.firstIndex(of: pokedex)!) * 35 : 0)
                        .onTapGesture {
                            selectedPokedex = pokedex
                            showView.toggle()
                        }
                }
                
                if selectedPokedex != nil {
                    PokedexSelectedView(name: "National")
                        .frame(width: sourceFrame.width, height: sourceFrame.height)
                        .offset(y: showView ? CGFloat(filteredPokedexes.count * 35) : 0)
                        .onTapGesture {
                            selectedPokedex = nil
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

struct MoveDamageClassSelectionView: View {
    let moveDamageClasses: [MoveDamageClass]
    
    @Binding var sourceFrame: CGRect
    @Binding var showView: Bool
    @Binding var selectedMoveDamageClass: MoveDamageClass?
    
    private var filteredMoveDamageClasses: [MoveDamageClass] {
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

struct PokedexFilterView_Previews: PreviewProvider {
    static var previews: some View {
        PokedexFilterView(generations: Array(testRealm.objects(Generation.self)), moveDamageClasses: Array(testRealm.objects(MoveDamageClass.self)), selectedVersionGroup: .constant(testRealm.object(ofType: VersionGroup.self, forPrimaryKey: 1)!), selectedVersion: .constant(testRealm.object(ofType: Version.self, forPrimaryKey: 1)!), selectedPokedex: testRealm.object(ofType: Pokedex.self, forPrimaryKey: 1)!, selectedMoveDamageClass: nil, selectedDexCategory: .pokémon, pokedexSelectedViewSourceFrame: .constant(.zero), showPokedexSelectionView: .constant(false), moveDamageClassSelectedViewSourceFrame: .constant(.zero), showMoveDamageClassSelectionView: .constant(false))
            .previewLayout(.sizeThatFits)
    }
}
