//
//  PokemonBreedingInfoView.swift
//  SwiftDex
//
//  Created by Brian Corbin on 4/4/22.
//

import SwiftUI

struct PokemonBreedingInfo {
    let extraInfo: SpeciesExtraInfo
    let eggGroups: [EggGroupInfo]
    let stats: [PokemonStatInfo]
    let types: [TypeEffectiveness.TypeData]
}

struct PokemonBreedingInfoView: View {
    let breedingInfo: PokemonBreedingInfo
    let color: Color
    
    var body: some View {
        ScrollView {
            VStack {
                Group {
                    SpeciesExtraInfoView(extraInfo: breedingInfo.extraInfo)
                    EggGroupsInfoView(eggGroups: breedingInfo.eggGroups, color: color)
                    EVYieldsInfoView(stats: breedingInfo.stats)
                    PokemonTypeWeaknessesInfoView(types: breedingInfo.types)
                }
                .padding()
            }
        }
    }
}

struct PokemonBreedingInfoView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonBreedingInfoView(breedingInfo: testBreedingInfo, color: .grass)
    }
}
