//
//  PokemonBasicInfoView.swift
//  SwiftDex
//
//  Created by Brian Corbin on 4/3/22.
//

import SwiftUI

struct PokemonBasicInfo {
    let speciesInfo: SpeciesInfo
    let abilitySlot1: PokemonAbilityInfo
    let abilitySlot2: PokemonAbilityInfo?
    let abilitySlot3: PokemonAbilityInfo?
    let stats: [PokemonStatInfo]
    let speciesVariations: [PokemonSummary]
    let forms: [PokemonForm]
}

struct PokemonBasicInfoView: View {
    let basicInfo: PokemonBasicInfo
    let color: Color
    @Binding var selectedPokemon: PokemonSummary?
    
    var body: some View {
        ScrollView {
            VStack {
                Group {
                    SpeciesInfoView(speciesInfo: basicInfo.speciesInfo, color: color)
                    PokemonAbilitiesInfoView(slot1Ability: basicInfo.abilitySlot1, slot2Ability: basicInfo.abilitySlot2, slot3Ability: basicInfo.abilitySlot3, color: color)
                    PokemonStatsInfoView(stats: basicInfo.stats, color: color)
                    SpeciesVariationsView(speciesVariations: basicInfo.speciesVariations, selectedPokemon: $selectedPokemon)
                }
                .padding()
            }
        }
    }
}

struct PokemonBasicInfoView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonBasicInfoView(basicInfo: venusaurBasicInfo, color: .grass, selectedPokemon: .constant(venusaurSummary))
    }
}
