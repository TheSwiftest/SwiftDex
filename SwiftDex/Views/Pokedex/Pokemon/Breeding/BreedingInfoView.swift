//
//  PokemonBreedingInfoView.swift
//  SwiftDex
//
//  Created by Brian Corbin on 4/4/22.
//

import SwiftUI

struct PokemonBreedingInfo {
    let extraInfo: SpeciesExtraInfo
    let eggGroups: [EggGroup]
    let stats: [PokemonStat]
    let types: [TypeEffectiveness.TypeData]
    
    init(pokemon: Pokemon) {
        self.extraInfo = SpeciesExtraInfo(catchRate: pokemon.species!.captureRate, baseHappiness: pokemon.species!.baseHappiness, baseExperience: pokemon.baseExperience, growthRate: pokemon.species!.growthRate!.name, eggCycles: pokemon.species!.hatchCounter, genderRate: pokemon.species!.genderRate)
        self.eggGroups = Array(pokemon.species!.eggGroups.map({$0.eggGroup!}))
        self.stats = Array(pokemon.stats)
        self.types = Array(pokemon.types.map({$0.type!.typeData}))
    }
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
        PokemonBreedingInfoView(breedingInfo: PokemonBreedingInfo(pokemon: testRealm.object(ofType: Pokemon.self, forPrimaryKey: 1)!), color: .grass)
            .previewLayout(.sizeThatFits)
    }
}
