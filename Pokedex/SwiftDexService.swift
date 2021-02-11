//
//  SwiftDexService.swift
//  Pokedex
//
//  Created by TempUser on 1/30/21.
//

import Foundation
import SwiftUI
import RealmSwift
import AVFoundation

class SwiftDexService: ObservableObject {    
    private var avPlayer = AVPlayer()
    
    private let realm = try! Realm(configuration: Realm.Configuration(fileURL: URL(fileURLWithPath: Bundle.main.path(forResource: "swiftdex", ofType: nil)!), readOnly: true))
    
    @Published var selectedVersionGroup: VersionGroup {
        didSet {
            selectedPokedex = selectedVersionGroup.pokedexes.first!.pokedex!
        }
    }
    
    @Published var selectedPokedex: Pokedex
    
    @Published var selectedVersion: Version
        
    var selectedRegion: Region? {
        return selectedVersionGroup.generation?.mainRegion
    }
    
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
        
    init() {
        let mostRecentVersionGroup = realm.object(ofType: VersionGroup.self, forPrimaryKey: 18)!
        self.selectedVersionGroup = mostRecentVersionGroup
        self.selectedPokedex = realm.object(ofType: Pokedex.self, forPrimaryKey: 1)!
        self.selectedVersion = mostRecentVersionGroup.versions.first!
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
    
    var allMoves: Results<Move> {
        return realm.objects(Move.self).sorted(byKeyPath: "identifier")
    }
    
    var allPokemon: Results<Pokemon> {
        return realm.objects(Pokemon.self)  
    }
    
    func pokemon(withId id: Int) -> Pokemon? {
        return realm.object(ofType: Pokemon.self, forPrimaryKey: id)
    }
    
    var natures: Results<Nature> {
        return realm.objects(Nature.self).sorted(byKeyPath: "identifier")
    }
    
    var items: Results<Item> {
        return realm.objects(Item.self).sorted(byKeyPath: "identifier")
    }
    
    func move(with name: String?) -> Move? {
        guard var name = name else { return nil }
        
        if name.starts(with: "Hidden Power") {
            name = "Hidden Power"
        }
        
        return realm.objects(MoveName.self).filter("name == '\(name)'").first?.move
    }
    
    func moves(matching text: String?) -> Results<Move> {
        guard let text = text else { return allMoves }
        if text.isEmpty { return allMoves }
        return allMoves.filter("ANY names.name CONTAINS [c] '\(text)'")
    }
    
    func moves(matching text: String?, for pokemon: Pokemon?) -> [Move] {
        guard let pokemon = pokemon else { return moves(matching: text).compactMap({$0}) }
        
        let results = pokemon.moves.filter("versionGroup.id == 18").distinct(by: ["move.id"])
        guard let text = text, !text.isEmpty else { return results.compactMap({ $0.move }) }
        
        return results.filter("ANY move.names.name CONTAINS [c] '\(text)'").compactMap({$0.move})
    }
    
    func playCry(for species: PokemonSpecies) {
        let playerItem = AVPlayerItem(url: URL(string: "https://pokemoncries.com/cries/\(species.id).mp3")!)
        avPlayer = AVPlayer(playerItem: playerItem)
        avPlayer.play()
    }
    
    func nature(with name: String?) -> Nature? {
        guard let name = name else { return nil }
        return realm.objects(NatureName.self).filter("name == '\(name)'").first?.nature
    }
    
    func item(with name: String?) -> Item? {
        guard let name = name else { return nil }
        return realm.objects(ItemName.self).filter("name == '\(name)'").first?.item
    }
    
    func pokemon(matching text: String?) -> Results<Pokemon> {
        guard let text = text else { return allPokemon.sorted(byKeyPath: "species.id") }
        
        if text.isEmpty { return allPokemon.sorted(byKeyPath: "species.id") }
        
        return realm.objects(Pokemon.self).filter("ANY species.names.name CONTAINS [c] '\(text)' OR ANY forms.names.pokemonName CONTAINS [c] '\(text)'").sorted(byKeyPath: "species.id")
    }
    
    func pokemonDexNumbers(matching text: String?) -> Results<PokemonDexNumber> {
        guard let text = text else { return selectedPokedex.pokemonSpeciesDexNumbers.sorted(byKeyPath: "pokedexNumber") }
        if text.isEmpty { return selectedPokedex.pokemonSpeciesDexNumbers.sorted(byKeyPath: "pokedexNumber") }
        
        return selectedPokedex.pokemonSpeciesDexNumbers.filter("ANY pokemon.forms.names.pokemonName CONTAINS [c] '\(text)'").sorted(byKeyPath: "pokedexNumber")
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
    
    func itemsForCurrentVersionGroup(in itemPocket: ItemPocket?, andOf itemCategory: ItemCategory?) -> [Item] {
        var itemGameIndices = selectedVersionGroup.generation!.itemGameIndices.sorted(byKeyPath: "item.category.pocket.id", ascending: true)
        
        if let itemPocket = itemPocket {
            itemGameIndices = itemGameIndices.filter("item.category.pocket.id == \(itemPocket.id)")
        }
        
        if let itemCategory = itemCategory {
            itemGameIndices = itemGameIndices.filter("item.category.id == \(itemCategory.id)")
        }
        
        return itemGameIndices.compactMap({$0.item})
    }
    
    func damageClasses() -> Results<MoveDamageClass> {
        return realm.objects(MoveDamageClass.self)
    }
    
    func itemPockets() -> Results<ItemPocket> {
        return realm.objects(ItemPocket.self)
    }
    
    func movesForVersionGroup(of moveDamageClass: MoveDamageClass?) -> Results<Move> {
        var moves = realm.objects(Move.self).filter("generation.id <= \(selectedVersionGroup.generation!.id)")
        
        if let moveDamageClass = moveDamageClass {
            moves = moves.filter("damageClass.id == \(moveDamageClass.id)")
        }
        
        return moves
    }
    
    func abilitiesForVersionGroup() -> [Ability] {
        return realm.objects(Ability.self).filter("generation.id <= \(selectedVersionGroup.generation!.id)").compactMap({$0})
    }
    
    func pokedexesForVersionGroup() -> [Pokedex] {
        var pokedexes: [Pokedex] = selectedVersionGroup.pokedexes.sorted(byKeyPath: "pokedex.id", ascending: true).compactMap({$0.pokedex})
        pokedexes.insert(nationalPokedex, at: 0)
        pokedexes.removeAll(where: {$0.id == selectedPokedex.id})
        return pokedexes
    }
    
    var nationalPokedex: Pokedex {
        return realm.object(ofType: Pokedex.self, forPrimaryKey: 1)!
    }
    
    var swordAndShieldVersionGroup: VersionGroup {
        return realm.object(ofType: VersionGroup.self, forPrimaryKey: 20)!
    }
    
    var generations: [Generation] {
        return realm.objects(Generation.self).map({$0})
    }
    
    var versionGroups: Results<VersionGroup> {
        return realm.objects(VersionGroup.self)
    }
    
    var versions: Results<Version> {
        return realm.objects(Version.self)
    }
        
    var moveLearnMethodsForSelectedVersionGroup: [PokemonMoveMethod] {
        return selectedVersionGroup.pokemonMoveMethods.filter("pokemonMoveMethod.id<=4").sorted(byKeyPath: "pokemonMoveMethod.id", ascending: true).compactMap({$0.pokemonMoveMethod})
    }
}
