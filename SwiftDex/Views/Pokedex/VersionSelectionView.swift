//
//  VersionSelectionView.swift
//  SwiftDex
//
//  Created by Brian Corbin on 6/20/22.
//

import SwiftUI
import RealmSwift

struct VersionGroupSelectionView: View {
    let generations: [Generation]

    @Binding var selectedVersionGroup: VersionGroup
    @Binding var selectedVersion: Version

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
    
    let generation: Generation

    @Binding var selectedVersionGroup: VersionGroup
    @Binding var selectedVersion: Version

    var body: some View {
        VStack {
            Text(generation.name)
            ForEach(generation.versionGroups) { versionGroup in
                HStack {
                    ForEach(versionGroup.versions.filter("id != 19 AND id != 20")) { version in
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

//struct VersionSelectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            GenerationVersionsSelectionView(generation: testRealm.object(ofType: Generation.self, forPrimaryKey: 1)!, selectedVersionGroup: .constant(VersionGroup()), selectedVersion: .constant(Version()))
//            VersionGroupSelectionView(generations: Array(testRealm.objects(Generation.self)), selectedVersionGroup: .constant(VersionGroup()), selectedVersion: .constant(Version()))
//        }
//        .previewLayout(.sizeThatFits)
//    }
//}
