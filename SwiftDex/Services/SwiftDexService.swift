//
//  SwiftDexService.swift
//  SwiftDex
//
//  Created by Brian Corbin on 4/9/22.
//

import Foundation

class SwiftDexService: ObservableObject {
    @Published var selectedVersionGroup: VersionGroupInfo {
        didSet {
            self.selectedPokedex = selectedVersionGroup.pokedexes.first!
        }
    }
    
    @Published var selectedVersion: VersionInfo {
        didSet {
            filterSearchText = ""
        }
    }
    
    @Published var selectedPokedex: PokedexInfo
        
    @Published var pokemonFiltered: [PokemonSummary]
    @Published var movesFiltered: [MoveInfo]
    
    @Published var filterSearchText: String = "" {
        didSet {
            setFilteredPokemon()
            setFilteredMoves()
        }
    }
    
    let generations: [GenerationInfo]
    
    let moveDamageClasses: [MoveDamageClassInfo]
    
    init() {
        let desiredVersionGroup = testGenerations.last!.versionGroups.last!
        self.generations = testGenerations
        self.moveDamageClasses = testMDCs
        self.selectedVersionGroup = desiredVersionGroup
        self.selectedVersion = desiredVersionGroup.versions.first!
        self.selectedPokedex = desiredVersionGroup.pokedexes.first!
        self.pokemonFiltered = testPokemonSummaries
        self.movesFiltered = testMoves
    }
    
    private func setFilteredPokemon() {
        if filterSearchText.isEmpty {
            pokemonFiltered = testPokemonSummaries
            return
        }
        
        pokemonFiltered = testPokemonSummaries.filter({$0.name.localizedCaseInsensitiveContains(filterSearchText)})
    }
    
    private func setFilteredMoves() {
        if filterSearchText.isEmpty {
            movesFiltered = testMoves
            return
        }
        
        movesFiltered = testMoves.filter({$0.name.localizedCaseInsensitiveContains(filterSearchText)})
    }
    
    func infoForPokemon(with id: Int) -> PokemonInfo {
        return testPokemonInfos.first(where: {$0.id == id})!
    }
}
