//
//  SwiftDexService.swift
//  SwiftDex
//
//  Created by Brian Corbin on 4/9/22.
//

import Foundation
import RealmSwift

class SwiftDexService: ObservableObject {
    private static let realm = try! Realm(configuration: Realm.Configuration(fileURL: URL(fileURLWithPath: Bundle.main.path(forResource: "swiftdex", ofType: "realm")!), readOnly: true))
    
    @Published var selectedVersionGroup: VersionGroup {
        didSet {
            self.selectedPokedex = selectedVersionGroup.pokedexes.first?.pokedex
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
    
    @Published var selectedItemPocket: ItemPocket? = nil
        
    @Published var filterSearchText: String = ""
    
    var pokemonDexNumbers: [PokemonDexNumber] {
        var query = SwiftDexService.realm.objects(PokemonDexNumber.self)
        
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
        var query = SwiftDexService.realm.objects(Move.self).filter("generation.id <= \(selectedVersionGroup.generation!.id)")
        
        if !filterSearchText.isEmpty {
            query = query.filter("ANY names.name CONTAINS [c] \"\(filterSearchText)\"")
        }
        
        if let selectedMoveDamageClass = selectedMoveDamageClass {
            query = query.filter("damageClass.id == \(selectedMoveDamageClass.id)")
        }
        
        return Array(query.sorted(byKeyPath: "identifier"))
    }
    
    var items: [Item] {
        return SwiftDexService.items(forGeneration: selectedVersionGroup.generation!, andPocket: selectedItemPocket, andSearchText: filterSearchText)
    }
    
    static func items(forGeneration generation: Generation, andPocket pocket: ItemPocket?, andSearchText searchText: String) -> [Item] {
        var query = Self.realm.objects(Item.self).filter("ANY gameIndices.generation.id <= \(generation.id)")
        if let pocket = pocket {
            query = query.filter("category.pocket.id == \(pocket.id)")
        }
        
        if !searchText.isEmpty {
            query = query.filter("ANY names.name CONTAINS [c] \"\(searchText)\"")
        }
        
        return Array(query.sorted(byKeyPath: "identifier"))
    }
    
    var abilities: [Ability] {
        return SwiftDexService.abilities(forGeneration: selectedVersionGroup.generation!, andSearchText: filterSearchText)
    }
    
    static func abilities(forGeneration generation: Generation, andSearchText searchText: String) -> [Ability] {
        var query = Self.realm.objects(Ability.self).filter("generation.id <= \(generation.id)")
        
        if !searchText.isEmpty {
            query = query.filter("ANY names.name CONTAINS [c] \"\(searchText)\"")
        }
        
        return Array(query.sorted(byKeyPath: "identifier"))
    }
        
    var generations: [Generation] {
        return Array(SwiftDexService.realm.objects(Generation.self))
    }
    
    var moveDamageClasses: [MoveDamageClass] {
        return Array(SwiftDexService.realm.objects(MoveDamageClass.self))
    }
    
    var itemPockets: [ItemPocket] {
        return Array(SwiftDexService.realm.objects(ItemPocket.self))
    }
        
    init() {
        let mostRecentVersionGroup = SwiftDexService.realm.object(ofType: VersionGroup.self, forPrimaryKey: 20)!
        self.selectedVersionGroup = mostRecentVersionGroup
        self.selectedVersion = mostRecentVersionGroup.versions.first!
    }
    
    func speciesVariations(for pokemon: Pokemon) -> [Pokemon] {
        return SwiftDexService.speciesVariations(for: pokemon, in: selectedVersionGroup)
    }
    
    static func speciesVariations(for pokemon: Pokemon, in versionGroup: VersionGroup) -> [Pokemon] {
        var query = SwiftDexService.realm.objects(PokemonForm.self).filter("pokemon.species.id == \(pokemon.species!.id) AND pokemon.id != \(pokemon.id)")
        query = query.filter("introducedInVersionGroup.id <= \(versionGroup.id)")
        query = query.filter("isBattleOnly == false")
        
        return Array(Set(query.map({$0.pokemon!})))
    }
    
    func alternateForms(for pokemon: Pokemon) -> [PokemonForm] {
        return SwiftDexService.alternateForms(for: pokemon, in: selectedVersionGroup)
    }
    
    static func alternateForms(for pokemon: Pokemon, in versionGroup: VersionGroup) -> [PokemonForm] {
        let query = SwiftDexService.realm.objects(PokemonForm.self).filter("pokemon.id == \(pokemon.id)").filter("introducedInVersionGroup.id <= \(versionGroup.id)")
        
        return Array(query)
    }
    
    func moves(for pokemon: Pokemon) -> [PokemonMove] {
        let query = SwiftDexService.realm.objects(PokemonMove.self).filter("pokemon.id == \(pokemon.id) AND versionGroup.id == \(selectedVersionGroup.id)")
        
        return Array(query)
    }
    
    func battleOnlyForms(for pokemon: Pokemon) -> [PokemonForm] {
        return SwiftDexService.battleOnlyForms(for: pokemon, in: selectedVersionGroup)
    }
    
    static func battleOnlyForms(for pokemon: Pokemon, in versionGroup: VersionGroup) -> [PokemonForm] {
        var query = Self.realm.objects(PokemonForm.self).filter("isBattleOnly == true AND identifier CONTAINS [c] \"\(pokemon.species!.identifier)\"")
        query = query.filter("introducedInVersionGroup.id <= \(versionGroup.id)")
        
        return Array(query)
    }
}

// Team Builder and Battle Sim helpers
extension SwiftDexService {
    static func version(withId id: Int) -> Version? {
        return Self.realm.object(ofType: Version.self, forPrimaryKey: id)
    }
    
    static func versionGroup(withId id: Int) -> VersionGroup? {
        return Self.realm.object(ofType: VersionGroup.self, forPrimaryKey: id)
    }
    
    static var female: Gender {
        return Self.realm.object(ofType: Gender.self, forPrimaryKey: 1)!
    }

    static var male: Gender {
        return Self.realm.object(ofType: Gender.self, forPrimaryKey: 2)!
    }
    
    static var genderless: Gender {
        return Self.realm.object(ofType: Gender.self, forPrimaryKey: 3)!
    }
    
    static func gender(with id: Int?) -> Gender? {
        guard let id = id else { return nil }
        return Self.realm.objects(Gender.self).filter("id == \(id)").first
    }
    
    static var showdownFormats: Results<ShowdownFormat> {
        return Self.realm.objects(ShowdownFormat.self)
    }
    
    static func showdownCategories(for generation: Generation?) -> Results<ShowdownCategory> {
        guard let generation = generation else { return showdownCategories }
        return showdownCategories.filter("ANY formats.generation.id == \(generation.id)")
    }

    static var showdownCategories: Results<ShowdownCategory> {
        return Self.realm.objects(ShowdownCategory.self)
    }
    
    static func move(with name: String?) -> Move? {
        guard var name = name else { return nil }

        if name.starts(with: "Hidden Power") {
            name = "Hidden Power"
        }

        return Self.realm.objects(MoveName.self).filter("name == \"\(name)\"").first?.move
    }
    
    static var natures: [Nature] {
        return Array(Self.realm.objects(Nature.self))
    }
    
    static func nature(with name: String?) -> Nature? {
        guard let name = name else { return nil }
        return Self.realm.objects(NatureName.self).filter("name == \"\(name)\"").first?.nature
    }
    
    static func nature(withId id: Int) -> Nature? {
        return Self.realm.object(ofType: Nature.self, forPrimaryKey: id)
    }
    
    static var items: [Item] {
        return Array(Self.realm.objects(Item.self))
    }
    
    static func item(with name: String?) -> Item? {
        guard let name = name else { return nil }
        return Self.realm.objects(ItemName.self).filter("name == \"\(name)\"").first?.item
    }
    
    static func item(withId id: Int) -> Item? {
        return Self.realm.object(ofType: Item.self, forPrimaryKey: id)
    }
    
    static var pokemon: [Pokemon] {
        return Array(Self.realm.objects(Pokemon.self).sorted(byKeyPath: "species.id"))
    }
    
    static func pokemon(matching text: String?) -> [Pokemon] {
        guard let text = text else { return Self.pokemon }

        if text.isEmpty { return Self.pokemon }

        return Array(realm.objects(Pokemon.self).filter("ANY species.names.name CONTAINS [c] \"\(text)\" OR ANY forms.names.pokemonName CONTAINS [c] \"\(text)\"").sorted(byKeyPath: "species.id"))
    }
    
    static func pokemon(withId id: Int) -> Pokemon? {
        return Self.realm.object(ofType: Pokemon.self, forPrimaryKey: id)
    }
    
    static func pokemon(with name: String?) -> Pokemon? {
        guard let name = name else { return nil }
        if name.isEmpty { return nil }
        if let pokemon = Self.realm.objects(PokemonFormName.self).filter("pokemonName == '\(name)'").first?.pokemonForm?.pokemon {
            return pokemon
        }

        if let pokemon = Self.realm.objects(PokemonSpeciesName.self).filter("name == '\(name)'").first?.pokemonSpecies?.defaultForm {
            return pokemon
        }

        if let pokemon = Self.realm.objects(Pokemon.self).filter("identifier == '\(name.lowercased())'").first {
            return pokemon
        }

        return nil
    }
    
    static func ability(withId id: Int) -> Ability? {
        return Self.realm.object(ofType: Ability.self, forPrimaryKey: id)
    }

    static func ability(with name: String?) -> Ability? {
        guard let name = name else { return nil }
        return Self.realm.objects(AbilityName.self).filter("name == '\(name)'").first?.ability
    }
    
    static func moves(matching text: String?) -> Results<Move> {
        let allMoves = realm.objects(Move.self).sorted(byKeyPath: "identifier")
        guard let text = text else { return allMoves }
        if text.isEmpty { return allMoves }
        return allMoves.filter("ANY names.name CONTAINS [c] \"\(text)\"")
    }
    
    static func moves(matching text: String?, for pokemon: Pokemon?) -> [Move] {
        guard let pokemon = pokemon else { return moves(matching: text).compactMap({ $0 }) }

        let results = pokemon.moves.filter("versionGroup.id == 18").distinct(by: ["move.id"])
        guard let text = text, !text.isEmpty else { return results.compactMap({ $0.move }) }

        return results.filter("ANY move.names.name CONTAINS [c] \"\(text)\"").compactMap({ $0.move })
    }
}
