//
//  SwiftDexService.swift
//  SwiftDex
//
//  Created by Brian Corbin on 4/9/22.
//

import Foundation
import RealmSwift

class SwiftDexService: ObservableObject {
    private let realm = try! Realm(configuration: Realm.Configuration(fileURL: URL(fileURLWithPath: Bundle.main.path(forResource: "swiftdex", ofType: "realm")!), readOnly: true))
    
    @Published var selectedVersionGroup: VersionGroup {
        didSet {
            self.selectedPokedex = selectedVersionGroup.pokedexes.first!.pokedex!
        }
    }
    
    @Published var selectedVersion: Version {
        didSet {
            filterSearchText = ""
        }
    }
    
    @Published var selectedPokedex: Pokedex? {
        didSet {
            filterSearchText = ""
        }
    }
    
    @Published var selectedMoveDamageClass: MoveDamageClass? = nil
        
    @Published var filterSearchText: String = ""
    
    var pokemonDexNumbers: [PokemonDexNumber] {
        var query = realm.objects(PokemonDexNumber.self)
        
        if let pokedex = selectedPokedex {
            query = query.filter("pokedex.id == \(pokedex.id)")
        } else {
            query = query.filter("pokedex.id == 1")
            query = query.filter("ANY pokemon.versionGameIndices.version.versionGroup.id <= \(self.selectedVersionGroup.id)")
        }
        
        if !filterSearchText.isEmpty {
            query = query.filter("ANY pokemon.forms.names.pokemonName CONTAINS [c] \"\(filterSearchText)\" OR ANY pokemon.species.names.name CONTAINS [c] \"\(filterSearchText)\"")
        }
        
        return Array(query.sorted(byKeyPath: "pokedexNumber"))
    }
    
    var moves: [Move] {
        var query = realm.objects(Move.self).filter("generation.id <= \(selectedVersionGroup.generation!.id)")
        
        if !filterSearchText.isEmpty {
            query = query.filter("ANY names.name CONTAINS [c] \"\(filterSearchText)\"")
        }
        
        if let selectedMoveDamageClass = selectedMoveDamageClass {
            query = query.filter("damageClass.id == \(selectedMoveDamageClass.id)")
        }
        
        return Array(query.sorted(byKeyPath: "identifier"))
    }
        
    var generations: [Generation] {
        return Array(realm.objects(Generation.self))
    }
    
    var moveDamageClasses: [MoveDamageClass] {
        return Array(realm.objects(MoveDamageClass.self))
    }
        
    init() {
        let mostRecentVersionGroup = realm.object(ofType: VersionGroup.self, forPrimaryKey: 20)!
        self.selectedVersionGroup = mostRecentVersionGroup
        self.selectedVersion = mostRecentVersionGroup.versions.first!
    }
    
    func speciesVariations(for pokemon: Pokemon) -> [Pokemon] {
        
        var query = realm.objects(Pokemon.self).filter("species.id == \(pokemon.species!.id) AND id != \(pokemon.id)")
        query = query.filter("NOT identifier CONTAINS '-gmax' AND NOT identifier CONTAINS '-mega'")
        query = query.filter("ANY forms.introducedInVersionGroup.id <= \(selectedVersionGroup.id)")
        
        return Array(query)
    }
    
    func alternateForms(for pokemon: Pokemon) -> [PokemonForm] {
        let query = realm.objects(PokemonForm.self).filter("pokemon.id == \(pokemon.id)").filter("introducedInVersionGroup.id <= \(selectedVersionGroup.id)")
        
        return Array(query)
    }
    
    func moves(for pokemon: Pokemon) -> [PokemonMove] {
        let query = realm.objects(PokemonMove.self).filter("pokemon.id == \(pokemon.id) AND versionGroup.id == \(selectedVersionGroup.id)")
        
        return Array(query)
    }
}
