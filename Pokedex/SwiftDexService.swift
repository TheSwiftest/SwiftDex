//
//  SwiftDexService.swift
//  Pokedex
//
//  Created by TempUser on 1/30/21.
//

import Foundation
import SwiftUI
import RealmSwift

class SwiftDexService: ObservableObject {
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
        
    init() {
        let mostRecentVersionGroup = realm.object(ofType: VersionGroup.self, forPrimaryKey: 18)!
        self.selectedVersionGroup = mostRecentVersionGroup
        self.selectedPokedex = realm.object(ofType: Pokedex.self, forPrimaryKey: 1)!
        self.selectedVersion = mostRecentVersionGroup.versions.first!
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
