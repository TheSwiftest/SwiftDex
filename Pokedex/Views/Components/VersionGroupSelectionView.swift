//
//  VersionSelectionView.swift
//  Pokedex
//
//  Created by BrianCorbin on 1/30/21.
//

import SwiftUI

struct VersionGroupSelectionView: View {
    let generations: [Generation]
    let pokemonFormRestriction: PokemonForm?

    @Binding var selectedVersionGroup: VersionGroup
    @Binding var selectedVersion: Version

    private var validGenerations: [Generation] {
        if let formRestriction = pokemonFormRestriction {
            return generations.filter({ $0.id >= formRestriction.introducedInVersionGroup!.generation!.id })
        }

        return generations.sorted(by: { $0.id > $1.id })
    }

    var body: some View {
        ScrollView {
            VStack {
                Text("Select A Version")
                    .font(.title2)
                ForEach(validGenerations, id: \.id) { generation in
                    GenerationVersionsSelectionView(generation: generation, selectedVersionGroup: $selectedVersionGroup, selectedVersion: $selectedVersion)
                }
            }
            .padding()
        }
    }
}

struct GenerationVersionsSelectionView: View {
    @Environment(\.presentationMode) var presentationMode

    let generation: Generation

    @Binding var selectedVersionGroup: VersionGroup
    @Binding var selectedVersion: Version

    var body: some View {
        VStack {
            Text(generation.names.first(where: { $0.localLanguageId == 9 })!.name)
            ForEach(generation.versionGroups.filter("id != 12 && id != 13 && id != 19"), id: \.id) { versionGroup in
                HStack {
                    ForEach(versionGroup.versions, id: \.id) { version in
                        Rectangle()
                            .frame(height: 30)
                            .foregroundColor(version.color)
                            .overlay(
                                Text(version.names.first(where: { $0.localLanguageId == 9 })?.name ?? version.identifier)
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
