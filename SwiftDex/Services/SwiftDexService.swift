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
            query = query.filter("ANY pokemon.forms.introducedInVersionGroup.id <= \(self.selectedVersionGroup.id)")
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

// Team Builder and Battle Sim helpers
extension SwiftDexService {
    var female: Gender {
        return realm.object(ofType: Gender.self, forPrimaryKey: 1)!
    }

    var male: Gender {
        return realm.object(ofType: Gender.self, forPrimaryKey: 2)!
    }
    
    var genderless: Gender {
        return realm.object(ofType: Gender.self, forPrimaryKey: 3)!
    }
    
    func gender(with id: Int?) -> Gender? {
        guard let id = id else { return nil }
        return realm.objects(Gender.self).filter("id == \(id)").first
    }
    
    var showdownFormats: Results<ShowdownFormat> {
        return realm.objects(ShowdownFormat.self)
    }
    
    func showdownCategories(for generation: Generation?) -> Results<ShowdownCategory> {
        guard let generation = generation else { return showdownCategories }
        return showdownCategories.filter("ANY formats.generation.id == \(generation.id)")
    }

    var showdownCategories: Results<ShowdownCategory> {
        return realm.objects(ShowdownCategory.self)
    }
    
    func move(with name: String?) -> Move? {
        guard var name = name else { return nil }

        if name.starts(with: "Hidden Power") {
            name = "Hidden Power"
        }

        return realm.objects(MoveName.self).filter("name == \"\(name)\"").first?.move
    }
    
    func nature(with name: String?) -> Nature? {
        guard let name = name else { return nil }
        return realm.objects(NatureName.self).filter("name == \"\(name)\"").first?.nature
    }

    func item(with name: String?) -> Item? {
        guard let name = name else { return nil }
        return realm.objects(ItemName.self).filter("name == \"\(name)\"").first?.item
    }
    
    func pokemon(withId id: Int) -> Pokemon? {
        return realm.object(ofType: Pokemon.self, forPrimaryKey: id)
    }
    
    func pokemon(with name: String?) -> Pokemon? {
        guard let name = name else { return nil }
        if name.isEmpty { return nil }
        if let pokemon = realm.objects(PokemonFormName.self).filter("pokemonName == '\(name)'").first?.pokemonForm?.pokemon {
            return pokemon
        }

        if let pokemon = realm.objects(PokemonSpeciesName.self).filter("name == '\(name)'").first?.pokemonSpecies?.defaultForm {
            return pokemon
        }

        if let pokemon = realm.objects(Pokemon.self).filter("identifier == '\(name.lowercased())'").first {
            return pokemon
        }

        return nil
    }

    func ability(with name: String?) -> Ability? {
        guard let name = name else { return nil }
        return realm.objects(AbilityName.self).filter("name == '\(name)'").first?.ability
    }
}
