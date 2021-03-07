//
//  VersionSelectionView.swift
//  Pokedex
//
//  Created by TempUser on 1/30/21.
//

import SwiftUI

struct VersionGroupSelectionView: View {
    @EnvironmentObject var swiftDexService: SwiftDexService

    var body: some View {
        ScrollView {
            VStack {
                Text("All Versions")
                ForEach(swiftDexService.generations, id: \.id) { generation in
                    VStack {
                        Text(generation.names.first(where: { $0.localLanguageId == 9 })!.name)
                        ForEach(generation.versionGroups, id: \.id) { versionGroup in
                            Text(versionGroup.identifier)
                        }
                    }
                }
            }
        }
    }
}

struct VersionSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        VersionGroupSelectionView().environmentObject(SwiftDexService())
    }
}
