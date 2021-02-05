//
//  RealmDataModels.swift
//  Realm Pokedex Gen
//
//  Created by TempUser on 1/28/21.
//


import Foundation
import Realm
import RealmSwift
import SwiftUI

class Ability: Object, Identifiable {
    @objc dynamic var id = 0
    @objc dynamic var identifier = ""
    @objc dynamic var isMainSeries = false
    @objc dynamic var generation: Generation?
    
    let changelogs = LinkingObjects(fromType: AbilityChangelog.self, property: "ability")
    let names = LinkingObjects(fromType: AbilityName.self, property: "ability")
    let prose = LinkingObjects(fromType: AbilityProse.self, property: "ability")
    let pokemonWithAbility = LinkingObjects(fromType: PokemonAbility.self, property: "ability")
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    var name: String {
        return names.first(where: {$0.localLanguageId == 9})?.name ?? identifier
    }
    
    var shortEffect: String {
        return prose.first(where: {$0.localLanguageId == 9})?.shortEffect ?? "No short effect"
    }
    
    var effect: String {
        return prose.first(where: {$0.localLanguageId == 9})?.effect ?? "No effect"
    }
}

class AbilityChangelog: Object {
    @objc dynamic var id = 0
    @objc dynamic var ability: Ability?
    
    let prose = LinkingObjects(fromType: AbilityChangelogProse.self, property: "abilityChangelog")
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

class AbilityChangelogProse: Object {
    @objc dynamic var localLanguageId = 0
    @objc dynamic var effect = ""
    @objc dynamic var abilityChangelog: AbilityChangelog?
}

class AbilityName: Object {
    @objc dynamic var localLanguageId = 0
    @objc dynamic var name = ""
    @objc dynamic var ability: Ability?
}

class AbilityProse: Object {
    @objc dynamic var localLanguageId = 0
    @objc dynamic var shortEffect = ""
    @objc dynamic var effect = ""
    @objc dynamic var ability: Ability?
}

class Berry: Object {
    @objc dynamic var id = 0
    @objc dynamic var item: Item?
    @objc dynamic var firmness: BerryFirmness?
    @objc dynamic var naturalGiftPower = 0
    @objc dynamic var naturalGiftType: Type?
    @objc dynamic var size = 0
    @objc dynamic var maxHarvest = 0
    @objc dynamic var growthTime = 0
    @objc dynamic var soilDryness = 0
    @objc dynamic var smoothness = 0
    
    let contestFlavors = LinkingObjects(fromType: BerryContestTypeFlavorValue.self, property: "berry")
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

class BerryFirmnessName: Object {
    @objc dynamic var berryFirmness: BerryFirmness?
    @objc dynamic var localLanguageId = 0
    @objc dynamic var name: String = ""
}

class BerryFirmness: Object {
    @objc dynamic var id = 0
    @objc dynamic var identifier = ""
    
    let names = LinkingObjects(fromType: BerryFirmnessName.self, property: "berryFirmness")
    let berriesWithFirmness = LinkingObjects(fromType: Berry.self, property: "firmness")
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

class BerryContestTypeFlavorValue: Object {
    @objc dynamic var berry: Berry?
    @objc dynamic var contestType: ContestType?
    @objc dynamic var flavorValue = 0
}

class CharacteristicText: Object {
    @objc dynamic var characteristic: Characteristic?
    @objc dynamic var localLanguageId = 0
    @objc dynamic var message = ""
}

// MARK: - Characteristic
class Characteristic: Object {
    @objc dynamic var id = 0
    @objc dynamic var stat: Stat?
    @objc dynamic var geneMod5 = 0
    
    let characteristicText = LinkingObjects(fromType: CharacteristicText.self, property: "characteristic")
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

// MARK: - ContestCombo
class ContestCombo: Object {
    @objc dynamic var firstMove: Move?
    @objc dynamic var secondMove: Move?
}

// MARK: - ContestEffectProse
class ContestEffectProse: Object {
    @objc dynamic var contestEffect: ContestEffect?
    @objc dynamic var localLanguageId = 0
    @objc dynamic var flavorText = ""
    @objc dynamic var effect = ""
}

// MARK: - ContestEffect
class ContestEffect: Object {
    @objc dynamic var id = 0
    @objc dynamic var appeal = 0
    @objc dynamic var jam = 0
    
    let prose = LinkingObjects(fromType: ContestEffectProse.self, property: "contestEffect")
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

// MARK: - ContestTypeName
class ContestTypeName: Object {
    @objc dynamic var contestType: ContestType?
    @objc dynamic var localLanguageId = 0
    @objc dynamic var name = ""
    @objc dynamic var flavor = ""
    @objc dynamic var color = ""
}

class ContestType: Object {
    @objc dynamic var id = 0
    @objc dynamic var identifier = ""
    
    let berryFlavorValues = LinkingObjects(fromType: BerryContestTypeFlavorValue.self, property: "contestType")
    let names = LinkingObjects(fromType: ContestTypeName.self, property: "contestType")
    let moves = LinkingObjects(fromType: Move.self, property: "contestType")
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

// MARK: - EggGroupProse
class EggGroupProse: Object {
    @objc dynamic var eggGroup: EggGroup?
    @objc dynamic var localLanguageId = 0
    @objc dynamic var name: String = ""
}

class EggGroup: Object, Identifiable {
    @objc dynamic var id = 0
    @objc dynamic var identifier = ""
    
    let prose = LinkingObjects(fromType: EggGroupProse.self, property: "eggGroup")
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    var name: String {
        return prose.first(where: {$0.localLanguageId == 9})?.name ?? identifier
    }
}

// MARK: - EncounterConditionValueMap
class EncounterConditionValueMap: Object {
    @objc dynamic var encounter: Encounter?
    @objc dynamic var encounterConditionValue: EncounterConditionValue?
}

// MARK: - EncounterConditionValueProse
class EncounterConditionValueProse: Object {
    @objc dynamic var encounterConditionValue: EncounterConditionValue?
    @objc dynamic var localLanguageId: Int = 0
    @objc dynamic var name: String = ""
}

// MARK: - EncounterConditionValue
class EncounterConditionValue: Object {
    @objc dynamic var id = 0
    @objc dynamic var encounterCondition: EncounterCondition?
    @objc dynamic var identifier: String = ""
    @objc dynamic var isDefault: Bool = false
    
    let prose = LinkingObjects(fromType: EncounterConditionValueProse.self, property: "encounterConditionValue")
    let encounters = LinkingObjects(fromType: EncounterConditionValueMap.self, property: "encounterConditionValue")
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

// MARK: - EncounterConditionProse
class EncounterConditionProse: Object {
    @objc dynamic var encounterCondition: EncounterCondition?
    @objc dynamic var localLanguageId: Int = 0
    @objc dynamic var name: String = ""
}

class EncounterCondition: Object {
    @objc dynamic var id = 0
    @objc dynamic var identifier = ""
    
    let prose = LinkingObjects(fromType: EncounterConditionProse.self, property: "encounterCondition")
    let encounterConditionValues = LinkingObjects(fromType: EncounterConditionValue.self, property: "encounterCondition")
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

// MARK: - EncounterMethodProse
class EncounterMethodProse: Object {
    @objc dynamic var encounterMethod: EncounterMethod?
    @objc dynamic var localLanguageId: Int = 0
    @objc dynamic var name: String = ""
}

// MARK: - EncounterMethod
class EncounterMethod: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var identifier: String = ""
    @objc dynamic var order: Int = 0
    
    let prose = LinkingObjects(fromType: EncounterMethodProse.self, property: "encounterMethod")
    let encounterSlots = LinkingObjects(fromType: EncounterSlot.self, property: "encounterMethod")
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

// MARK: - EncounterSlot
class EncounterSlot: Object {
    @objc dynamic var id = 0
    @objc dynamic var versionGroup: VersionGroup?
    @objc dynamic var encounterMethod: EncounterMethod?
    let slot = RealmOptional<Int>()
    @objc dynamic var rarity: Int = 0
    
    let encounters = LinkingObjects(fromType: Encounter.self, property: "encounterSlot")
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

// MARK: - Encounter
class Encounter: Object {
    @objc dynamic var id = 0
    @objc dynamic var version: Version?
    @objc dynamic var locationArea: LocationArea?
    @objc dynamic var encounterSlot: EncounterSlot?
    @objc dynamic var pokemon: Pokemon?
    @objc dynamic var minLevel = 0
    @objc dynamic var maxLevel: Int = 0
    
    let encounterConditions = LinkingObjects(fromType: EncounterConditionValueMap.self, property: "encounter")
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

// MARK: - EvolutionChain
class EvolutionChain: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var babyTriggerItem: Item?
    
    let pokemonSpeciesInChain = LinkingObjects(fromType: PokemonSpecies.self, property: "evolutionChain")
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

// MARK: - EvolutionTriggerProse
class EvolutionTriggerProse: Object {
    @objc dynamic var evolutionTrigger: EvolutionTrigger?
    @objc dynamic var localLanguageId: Int = 0
    @objc dynamic var name: String = ""
}

class EvolutionTrigger: Object {
    @objc dynamic var id = 0
    @objc dynamic var identifier = ""
    
    let prose = LinkingObjects(fromType: EvolutionTriggerProse.self, property: "evolutionTrigger")
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    var name: String {
        return prose.first(where: {$0.localLanguageId == 9})?.name ?? identifier
    }
}

// MARK: - Experience
class Experience: Object {
    @objc dynamic var growthRate: GrowthRate?
    @objc dynamic var level = 0
    @objc dynamic var experience: Int = 0
}

class Gender: Object {
    @objc dynamic var id = 0
    @objc dynamic var identifier = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    var name: String {
        return identifier
    }
}

// MARK: - GenerationName
class GenerationName: Object {
    @objc dynamic var generation: Generation?
    @objc dynamic var localLanguageId: Int = 0
    @objc dynamic var name: String = ""
}

// MARK: - Generation
class Generation: Object {
    @objc dynamic var id = 0
    @objc dynamic var mainRegion: Region?
    @objc dynamic var identifier: String = ""
    
    let versionGroups = LinkingObjects(fromType: VersionGroup.self, property: "generation")
    let moves = LinkingObjects(fromType: Move.self, property: "generation")
    let locationGameIndices = LinkingObjects(fromType: LocationGameIndex.self, property: "generation")
    let itemGameIndices = LinkingObjects(fromType: ItemGameIndex.self, property: "generation")
    let names = LinkingObjects(fromType: GenerationName.self, property: "generation")
    let abilities = LinkingObjects(fromType: Ability.self, property: "generation")
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

// MARK: - GrowthRateProse
class GrowthRateProse: Object {
    @objc dynamic var growthRate: GrowthRate?
    @objc dynamic var localLanguageId: Int = 0
    @objc dynamic var name: String = ""
}

// MARK: - GrowthRate
class GrowthRate: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var identifier = ""
    @objc dynamic var formula: String = ""
    
    let prose = LinkingObjects(fromType: GrowthRateProse.self, property: "growthRate")
    let experienceForLevels = LinkingObjects(fromType: Experience.self, property: "growthRate")
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    var name: String {
        return prose.first(where: {$0.localLanguageId == 9})?.name ?? identifier
    }
}

// MARK: - ItemCategory
class ItemCategory: Object {
    @objc dynamic var id = 0
    @objc dynamic var pocket: ItemPocket?
    @objc dynamic var identifier: String = ""
    
    let items = LinkingObjects(fromType: Item.self, property: "category")
    let prose = LinkingObjects(fromType: ItemCategoryProse.self, property: "itemCategory")
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    var name: String {
        return prose.first(where: {$0.localLanguageId == 9})?.name ?? identifier
    }
}

// MARK: - ItemCategoryProse
class ItemCategoryProse: Object {
    @objc dynamic var itemCategory: ItemCategory?
    @objc dynamic var localLanguageId: Int = 0
    @objc dynamic var name: String = ""
}

// MARK: - ItemFlagMap
class ItemFlagMap: Object {
    @objc dynamic var item: Item?
    @objc dynamic var itemFlag: ItemFlag?
}

// MARK: - ItemFlagProse
class ItemFlagProse: Object {
    @objc dynamic var itemFlag: ItemFlag?
    @objc dynamic var localLanguageId: Int = 0
    @objc dynamic var name = ""
    @objc dynamic var itemFlagProseDescription: String = ""
}

class ItemFlag: Object {
    @objc dynamic var id = 0
    @objc dynamic var identifier = ""
    
    let prose = LinkingObjects(fromType: ItemFlagProse.self, property: "itemFlag")
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

// MARK: - Item
class Item: Object, Identifiable {
    @objc dynamic var id: Int = 0
    @objc dynamic var identifier: String = ""
    @objc dynamic var category: ItemCategory?
    @objc dynamic var cost: Int = 0
    let flingPower = RealmOptional<Int>()
    @objc dynamic var flingEffect: ItemFlingEffect?
    
    let machines = LinkingObjects(fromType: Machine.self, property: "item")
    let names = LinkingObjects(fromType: ItemName.self, property: "item")
    let prose = LinkingObjects(fromType: ItemProse.self, property: "item")
    let gameIndices = LinkingObjects(fromType: ItemGameIndex.self, property: "item")
    let flavorTexts = LinkingObjects(fromType: ItemFlavorText.self, property: "item")
    let flags = LinkingObjects(fromType: ItemFlagMap.self, property: "item")
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    var name: String {
        return names.first(where: {$0.localLanguageId == 9})?.name ?? identifier
    }
    
    var imageURL: URL {
        return URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/items/\(identifier).png")!
    }
    
    func flavorText(for versionGroup: VersionGroup) -> String {
        return flavorTexts.first(where: {$0.languageId == 9 && $0.versionGroup!.id == versionGroup.id})?.flavorText.replacingOccurrences(of: "\n", with: " ") ?? "No Flavor Text"
    }
    
    var effectText: String {
        return prose.first(where: {$0.localLanguageId == 9})?.effect ?? "No item effect"
    }
    
    var shortEffectText: String {
        return prose.first(where: {$0.localLanguageId == 9})?.shortEffect ?? "No short effect text"
    }
}

// MARK: - ItemFlavorText
class ItemFlavorText: Object {
    @objc dynamic var item: Item?
    @objc dynamic var versionGroup: VersionGroup?
    @objc dynamic var languageId: Int = 0
    @objc dynamic var flavorText: String = ""
}

// Mark: - ItemFlingEffect
class ItemFlingEffect: Object {
    @objc dynamic var id = 0
    @objc dynamic var identifier = ""
    
    let prose = LinkingObjects(fromType: ItemFlingEffectProse.self, property: "itemFlingEffect")
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    var effect: String {
        return prose.first(where: {$0.localLanguageId == 9})?.effect ?? identifier
    }
}

// MARK: - ItemFlingEffectProse
class ItemFlingEffectProse: Object {
    @objc dynamic var itemFlingEffect: ItemFlingEffect?
    @objc dynamic var localLanguageId: Int = 0
    @objc dynamic var effect: String = ""
}

// MARK: - ItemGameIndex
class ItemGameIndex: Object {
    @objc dynamic var item: Item?
    @objc dynamic var generation: Generation?
    @objc dynamic var gameIndex: Int = 0
}

// MARK: - ItemName
class ItemName: Object {
    @objc dynamic var item: Item?
    @objc dynamic var localLanguageId: Int = 0
    @objc dynamic var name: String = ""
}

// MARK: - ItemPocketName
class ItemPocketName: Object {
    @objc dynamic var itemPocket: ItemPocket?
    @objc dynamic var localLanguageId: Int = 0
    @objc dynamic var name: String = ""
}

class ItemPocket: Object, Identifiable {
    @objc dynamic var id = 0
    @objc dynamic var identifier = ""
    
    let itemCategories = LinkingObjects(fromType: ItemCategory.self, property: "pocket")
    let names = LinkingObjects(fromType: ItemPocketName.self, property: "itemPocket")
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    var name: String {
        return names.first(where: {$0.localLanguageId == 9})?.name ?? identifier
    }
}

// MARK: - ItemProse
class ItemProse: Object {
    @objc dynamic var item: Item?
    @objc dynamic var localLanguageId: Int = 0
    @objc dynamic var shortEffect = ""
    @objc dynamic var effect: String = ""
}

class Language: Object {
    @objc dynamic var id = 0
    @objc dynamic var iso639 = ""
    @objc dynamic var iso3166 = ""
    @objc dynamic var identifier = ""
    @objc dynamic var official = 0
    @objc dynamic var order = 0

    let names = LinkingObjects(fromType: LanguageName.self, property: "language")
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

class LanguageName: Object {
    @objc dynamic var language: Language?
    @objc dynamic var localLanguage: Language?
    @objc dynamic var name = ""
}

class LocationAreaEncounterRate: Object {
    @objc dynamic var locationArea: LocationArea?
    @objc dynamic var encounterMethod: EncounterMethod?
    @objc dynamic var version: Version?
    @objc dynamic var rate = 0
}

// MARK: - LocationAreaProse
class LocationAreaProse: Object {
    @objc dynamic var locationArea: LocationArea?
    @objc dynamic var localLanguageId: Int = 0
    @objc dynamic var name: String = ""
}

// MARK: - LocationArea
class LocationArea: Object {
    @objc dynamic var id = 0
    @objc dynamic var location: Location?
    @objc dynamic var gameIndex: Int = 0
    @objc dynamic var identifier: String = ""
    
    let prose = LinkingObjects(fromType: LocationAreaProse.self, property: "locationArea")
    let encounterRates = LinkingObjects(fromType: LocationAreaEncounterRate.self, property: "locationArea")
    let encounters = LinkingObjects(fromType: Encounter.self, property: "locationArea")
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

// MARK: - LocationGameIndex
class LocationGameIndex: Object {
    @objc dynamic var location: Location?
    @objc dynamic var generation: Generation?
    @objc dynamic var gameIndex: Int = 0
}

// MARK: - LocationName
class LocationName: Object {
    @objc dynamic var location: Location?
    @objc dynamic var localLanguageId: Int = 0
    @objc dynamic var name = ""
    @objc dynamic var subtitle: String = ""
}

// MARK: - Location
class Location: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var region: Region?
    @objc dynamic var identifier: String = ""
    
    let names = LinkingObjects(fromType: LocationName.self, property: "location")
    let gameIndices = LinkingObjects(fromType: LocationGameIndex.self, property: "location")
    let areas = LinkingObjects(fromType: LocationArea.self, property: "location")
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    var name: String {
        return names.first(where: {$0.localLanguageId == 9})?.name ?? identifier
    }
}

// MARK: - Machine
class Machine: Object {
    @objc dynamic var machineNumber = 0
    @objc dynamic var versionGroup: VersionGroup?
    @objc dynamic var item: Item?
    @objc dynamic var move: Move?
}

// MARK: - MoveBattleStyleProse
class MoveBattleStyleProse: Object {
    @objc dynamic var moveBattleStyle: MoveBattleStyle?
    @objc dynamic var localLanguageId: Int = 0
    @objc dynamic var name: String = ""
}

class MoveBattleStyle: Object {
    @objc dynamic var id = 0
    @objc dynamic var identifier = ""
    
    let prose = LinkingObjects(fromType: MoveBattleStyleProse.self, property: "moveBattleStyle")
    let naturePreferences = LinkingObjects(fromType: NatureBattleStylePreference.self, property: "moveBattleStyle")
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

class Move: Object, Identifiable {
    @objc dynamic var id: Int = 0
    @objc dynamic var identifier: String = ""
    @objc dynamic var generation: Generation?
    @objc dynamic var type: Type?
    @objc dynamic var damageClass: MoveDamageClass?
    @objc dynamic var target: MoveTarget?
    let power = RealmOptional<Int>()
    let pp = RealmOptional<Int>()
    let accuracy = RealmOptional<Int>()
    @objc dynamic var priority: Int = 0
    @objc dynamic var effect: MoveEffect?
    let effectChance = RealmOptional<Int>()
    @objc dynamic var contestType: ContestType?
    @objc dynamic var contestEffect: ContestEffect?
    @objc dynamic var superContestEffect: SuperContestEffect?
    
    let names = LinkingObjects(fromType: MoveName.self, property: "move")
    let meta = LinkingObjects(fromType: MoveMeta.self, property: "move")
    let metaStatChanges = LinkingObjects(fromType: MoveMetaStatChange.self, property: "move")
    let flavorTexts = LinkingObjects(fromType: MoveFlavorText.self, property: "move")
    let flags = LinkingObjects(fromType: MoveFlagMap.self, property: "move")
    let changelogs = LinkingObjects(fromType: MoveChangelog.self, property: "move")
    let machines = LinkingObjects(fromType: Machine.self, property: "move")
    let firstInContestCombos = LinkingObjects(fromType: ContestCombo.self, property: "firstMove")
    let firstInSuperContestCombos = LinkingObjects(fromType: SuperContestCombo.self, property: "firstMove")
    let secondInContestCombos = LinkingObjects(fromType: ContestCombo.self, property: "secondMove")
    let secondInSuperContestCombos = LinkingObjects(fromType: SuperContestCombo.self, property: "secondMove")

    override static func primaryKey() -> String? {
        return "id"
    }
    
    var name: String {
        return names.first(where: {$0.localLanguageId == 9})?.name ?? identifier
    }
    
}

// MARK: - MoveChangelog
class MoveChangelog: Object {
    @objc dynamic var move: Move?
    @objc dynamic var changedInVersionGroup: VersionGroup?
    @objc dynamic var type: Type?
    let power = RealmOptional<Int>()
    let pp = RealmOptional<Int>()
    let accuracy = RealmOptional<Int>()
    let priority = RealmOptional<Int>()
    @objc dynamic var target: MoveTarget?
    @objc dynamic var effect: MoveEffect?
    let effectChance = RealmOptional<Int>()
}

class MoveDamageClass: Object, Identifiable {
    @objc dynamic var id = 0
    @objc dynamic var identifier = ""
    
    let prose = LinkingObjects(fromType: MoveDamageClassProse.self, property: "moveDamageClass")
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    var name: String {
        return prose.first(where: {$0.localLanguageId == 9})?.name ?? identifier
    }
    
    var color: Color {
        return Color("damage_class_\(identifier)")
    }
    
    var backgroundColor: Color {
        return Color("damage_class_\(identifier)_bg")
    }
    
    var icon: Image {
        return Image("damage_class_\(identifier)")
    }
}

class MoveDamageClassProse: Object {
    @objc dynamic var moveDamageClass: MoveDamageClass?
    @objc dynamic var localLanguageId = 0
    @objc dynamic var name = ""
    @objc dynamic var moveProseDescription = ""
}

// MARK: - MoveEffectChangelogProse
class MoveEffectChangelogProse: Object {
    @objc dynamic var moveEffectChangelog: MoveEffectChangelog?
    @objc dynamic var localLanguageId: Int = 0
    @objc dynamic var effect: String = ""
}

// MARK: - MoveEffectChangelog
class MoveEffectChangelog: Object {
    @objc dynamic var id = 0
    @objc dynamic var effect: MoveEffect?
    @objc dynamic var changedInVersionGroup: VersionGroup?
    
    let prose = LinkingObjects(fromType: MoveEffectChangelogProse.self, property: "moveEffectChangelog")
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

class MoveEffectProse: Object {
    @objc dynamic var moveEffect: MoveEffect?
    @objc dynamic var localLanguageId: Int = 0
    @objc dynamic var shortEffect: String = ""
    @objc dynamic var effect: String = ""
}

class MoveEffect: Object {
    @objc dynamic var id: Int = 0
    
    let prose = LinkingObjects(fromType: MoveEffectProse.self, property: "moveEffect")
    let changelogs = LinkingObjects(fromType: MoveEffectChangelog.self, property: "effect")
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    var shortEffectDescription: String {
        return prose.first(where: {$0.localLanguageId == 9})?.shortEffect ?? "No short effect"
    }
    
    var effectDescription: String {
        return prose.first(where: {$0.localLanguageId == 9})?.effect ?? "No effect description"
    }
}

// MARK: - MoveFlagMap
class MoveFlagMap: Object {
    @objc dynamic var move: Move?
    @objc dynamic var moveFlag: MoveFlag?
}

class MoveFlagProse: Object {
    @objc dynamic var moveFlag: MoveFlag?
    @objc dynamic var localLanguageId = 0
    @objc dynamic var name = ""
    @objc dynamic var moveProseDescription = ""
}

class MoveFlag: Object {
    @objc dynamic var id = 0
    @objc dynamic var identifier = ""
    
    let prose = LinkingObjects(fromType: MoveFlagProse.self, property: "moveFlag")
    let moves = LinkingObjects(fromType: MoveFlagMap.self, property: "moveFlag")
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

// MARK: - MoveFlavorText
class MoveFlavorText: Object {
    @objc dynamic var move: Move?
    @objc dynamic var versionGroup: VersionGroup?
    @objc dynamic var languageId: Int = 0
    @objc dynamic var flavorText: String = ""
}

// MARK: - MoveMetaAilmentName
class MoveMetaAilmentName: Object {
    @objc dynamic var moveMetaAilment: MoveMetaAilment?
    @objc dynamic var localLanguageId: Int = 0
    @objc dynamic var name: String = ""
}

class MoveMetaAilment: Object {
    @objc dynamic var id = 0
    @objc dynamic var identifier = ""
    
    let names = LinkingObjects(fromType: MoveMetaAilmentName.self, property: "moveMetaAilment")
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

class MoveMetaCategory: Object {
    @objc dynamic var id = 0
    @objc dynamic var identifier = ""
    
    let prose = LinkingObjects(fromType: MoveMetaCategoryProse.self, property: "moveMetaCategory")
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

// MARK: - MoveMetaCategoryProse
class MoveMetaCategoryProse: Object {
    @objc dynamic var moveMetaCategory: MoveMetaCategory?
    @objc dynamic var localLanguageId: Int = 0
    @objc dynamic var moveMetaCategoryProseDescription: String = ""
}

// MARK: - MoveMetaStatChange
class MoveMetaStatChange: Object {
    @objc dynamic var move: Move?
    @objc dynamic var stat: Stat?
    @objc dynamic var change: Int = 0
}

class MoveMeta: Object {
    @objc dynamic var move: Move?
    @objc dynamic var metaCategory: MoveMetaCategory? //
    @objc dynamic var metaAilment: MoveMetaAilment? //
    let minHits = RealmOptional<Int>()
    let maxHits = RealmOptional<Int>()
    let minTurns = RealmOptional<Int>()
    let maxTurns = RealmOptional<Int>()
    @objc dynamic var drain = 0
    @objc dynamic var healing = 0
    @objc dynamic var critRate = 0
    @objc dynamic var ailmentChance = 0
    @objc dynamic var flinchChance = 0
    @objc dynamic var statChance = 0
}

class MoveName: Object {
    @objc dynamic var move: Move?
    @objc dynamic var localLanguageId: Int = 0
    @objc dynamic var name: String = ""
}

class MoveTargetProse: Object {
    @objc dynamic var moveTarget: MoveTarget?
    @objc dynamic var localLanguageId: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var targetDescription: String = ""
}

class MoveTarget: Object {
    @objc dynamic var id = 0
    @objc dynamic var identifier = ""
    
    let prose = LinkingObjects(fromType: MoveTargetProse.self, property: "moveTarget")
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    var name: String {
        return prose.first(where: {$0.localLanguageId == 9})?.name ?? identifier
    }
    
    var targetDescription: String {
        return prose.first(where: {$0.localLanguageId == 9})?.targetDescription ?? "No target description"
    }
}

// MARK: - NatureBattleStylePreference
class NatureBattleStylePreference: Object {
    @objc dynamic var nature: Nature?
    @objc dynamic var moveBattleStyle: MoveBattleStyle?
    @objc dynamic var lowHPPreference = false
    @objc dynamic var highHPPreference = false
}

// MARK: - NatureName
class NatureName: Object {
    @objc dynamic var nature: Nature?
    @objc dynamic var localLanguageId: Int = 0
    @objc dynamic var name: String = ""
}

// MARK: - NaturePokeathlonStat
class NaturePokeathlonStat: Object {
    @objc dynamic var nature: Nature?
    @objc dynamic var pokeathlonStat: PokeathlonStat?
    @objc dynamic var maxChange: Int = 0
}

// MARK: - Nature
class Nature: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var identifier: String = ""
    @objc dynamic var decreasedStat: Stat?
    @objc dynamic var increasedStat: Stat?
    @objc dynamic var hatesFlavor: ContestType?
    @objc dynamic var likesFlavor: ContestType?
    @objc dynamic var gameIndex: Int = 0
    
    let pokeathlonStatChanges = LinkingObjects(fromType: NaturePokeathlonStat.self, property: "nature")
    let names = LinkingObjects(fromType: NatureName.self, property: "nature")
    let moveBattleStylePreferences = LinkingObjects(fromType: NatureBattleStylePreference.self, property: "nature")
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

// MARK: - PalParkAreaName
class PalParkAreaName: Object {
    @objc dynamic var palParkArea: PalParkArea?
    @objc dynamic var localLanguageId: Int = 0
    @objc dynamic var name: String = ""
}

// MARK: - PalParkArea
class PalParkArea: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var identifier: String = ""
    
    let names = LinkingObjects(fromType: PalParkAreaName.self, property: "palParkArea")
    let species = LinkingObjects(fromType: PalParkAreaSpecies.self, property: "area")
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

// MARK: - PalPark
class PalParkAreaSpecies: Object {
    @objc dynamic var species: PokemonSpecies?
    @objc dynamic var area: PalParkArea?
    @objc dynamic var baseScore = 0
    @objc dynamic var rate: Int = 0
}

// MARK: - PokeathlonStatName
class PokeathlonStatName: Object {
    @objc dynamic var pokeathlonStat: PokeathlonStat?
    @objc dynamic var localLanguageId: Int = 0
    @objc dynamic var name: String = ""
}

// MARK: - PokeathlonStat
class PokeathlonStat: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var identifier: String = ""
    
    let names = LinkingObjects(fromType: PokeathlonStatName.self, property: "pokeathlonStat")
    let changeFromNatures = LinkingObjects(fromType: NaturePokeathlonStat.self, property: "pokeathlonStat")
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

// MARK: - PokedexProse
class PokedexProse: Object {
    @objc dynamic var pokedex: Pokedex?
    @objc dynamic var localLanguageId: Int = 0
    @objc dynamic var name = ""
    @objc dynamic var pokedexProseDescription: String = ""
}

// MARK: - PokedexVersionGroup
class PokedexVersionGroup: Object {
    @objc dynamic var pokedex: Pokedex?
    @objc dynamic var versionGroup: VersionGroup?
}

// MARK: - Pokedex
class Pokedex: Object, Identifiable {
    @objc dynamic var id: Int = 0
    @objc dynamic var region: Region?
    @objc dynamic var identifier: String = ""
    @objc dynamic var isMainSeries = false
    
    let pokemonSpeciesDexNumbers = LinkingObjects(fromType: PokemonDexNumber.self, property: "pokedex")
    let versionGroups = LinkingObjects(fromType: PokedexVersionGroup.self, property: "pokedex")
    let prose = LinkingObjects(fromType: PokedexProse.self, property: "pokedex")
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    var name: String {
        return prose.first(where: {$0.localLanguageId == 9})?.name.replacingOccurrences(of: "Updated ", with: "").replacingOccurrences(of: "Original ", with: "").replacingOccurrences(of: "Extended ", with: "").replacingOccurrences(of: "New ", with: "") ?? identifier
    }
}

// MARK: - PokemonAbility
class PokemonAbility: Object {
    @objc dynamic var pokemon: Pokemon?
    @objc dynamic var ability: Ability?
    @objc dynamic var isHidden = false
    @objc dynamic var slot = 0
}

// MARK: - PokemonColorName
class PokemonColorName: Object {
    @objc dynamic var pokemonColor: PokemonColor?
    @objc dynamic var localLanguageId: Int = 0
    @objc dynamic var name: String = ""
}

// MARK: - PokemonColor
class PokemonColor: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var identifier: String = ""
    
    let names = LinkingObjects(fromType: PokemonColorName.self, property: "pokemonColor")
    let speciesWithColor = LinkingObjects(fromType: PokemonSpecies.self, property: "color")
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

// MARK: - PokemonDexNumber
class PokemonDexNumber: Object, Identifiable {
    @objc dynamic var species: PokemonSpecies?
    @objc dynamic var pokedex: Pokedex?
    @objc dynamic var pokedexNumber: Int = 0
    
    var id: String {
        return "\(pokedex!.identifier)-\(pokedexNumber)"
    }
}

// MARK: - PokemonEggGroup
class PokemonEggGroup: Object {
    @objc dynamic var species: PokemonSpecies?
    @objc dynamic var eggGroup: EggGroup?
}

// MARK: - PokemonEvolution
class PokemonEvolution: Object {
    @objc dynamic var id = 0
    @objc dynamic var evolvedSpecies: PokemonSpecies?
    @objc dynamic var evolutionTrigger: EvolutionTrigger?
    @objc dynamic var triggerItem: Item?
    let minimumLevel = RealmOptional<Int>()
    @objc dynamic var gender: Gender?
    @objc dynamic var location: Location?
    @objc dynamic var heldItem: Item?
    @objc dynamic var timeOfDay: String = ""
    @objc dynamic var knownMove: Move?
    @objc dynamic var knownMoveType: Type?
    let minimumHappiness = RealmOptional<Int>()
    let minimumBeauty = RealmOptional<Int>()
    let minimumAffection = RealmOptional<Int>()
    let relativePhysicalStats = RealmOptional<Int>()
    @objc dynamic var partySpecies: PokemonSpecies?
    @objc dynamic var partyType: Type?
    @objc dynamic var tradeSpecies: PokemonSpecies?
    @objc dynamic var needsOverworldRain = false
    @objc dynamic var turnUpsideDown = false
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

// MARK: - PokemonFormGeneration
class PokemonFormGeneration: Object {
    @objc dynamic var pokemonForm: PokemonForm?
    @objc dynamic var generation: Generation?
    @objc dynamic var gameIndex: Int = 0
}

// MARK: - PokemonFormName
class PokemonFormName: Object {
    @objc dynamic var pokemonForm: PokemonForm?
    @objc dynamic var localLanguageId: Int = 0
    @objc dynamic var formName = ""
    @objc dynamic var pokemonName: String = ""
}

// MARK: - PokemonFormPokeathlonStat
class PokemonFormPokeathlonStat: Object {
    @objc dynamic var pokemonForm: PokemonForm?
    @objc dynamic var pokeathlonStat: PokeathlonStat?
    @objc dynamic var minimumStat = 0
    @objc dynamic var baseStat: Int = 0
    @objc dynamic var maximumStat: Int = 0
}

// MARK: - PokemonForm
class PokemonForm: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var identifier = ""
    @objc dynamic var formIdentifier: String = ""
    @objc dynamic var pokemon: Pokemon?
    @objc dynamic var introducedInVersionGroup: VersionGroup?
    @objc dynamic var isDefault = false
    @objc dynamic var isBattleOnly = false
    @objc dynamic var isMega = false
    @objc dynamic var formOrder = 0
    @objc dynamic var order: Int = 0
    
    let names = LinkingObjects(fromType: PokemonFormName.self, property: "pokemonForm")
    let generations = LinkingObjects(fromType: PokemonFormGeneration.self, property: "pokemonForm")
    let pokeathlonStats = LinkingObjects(fromType: PokemonFormPokeathlonStat.self, property: "pokemonForm")
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

// MARK: - PokemonGameIndex
class PokemonGameIndex: Object {
    @objc dynamic var pokemon: Pokemon?
    @objc dynamic var version: Version?
    @objc dynamic var gameIndex: Int = 0
}

// MARK: - PokemonHabitatName
class PokemonHabitatName: Object {
    @objc dynamic var pokemonHabitat: PokemonHabitat?
    @objc dynamic var localLanguageId: Int = 0
    @objc dynamic var name: String = ""
}

// MARK: - Pokemon
class PokemonHabitat: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var identifier: String = ""
    
    let names = LinkingObjects(fromType: PokemonHabitatName.self, property: "pokemonHabitat")
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

// MARK: - PokemonItem
class PokemonItem: Object {
    @objc dynamic var pokemon: Pokemon?
    @objc dynamic var version: Version?
    @objc dynamic var item: Item?
    @objc dynamic var rarity: Int = 0
}

// MARK: - PokemonMoveMethodProse
class PokemonMoveMethodProse: Object {
    @objc dynamic var pokemonMoveMethod: PokemonMoveMethod?
    @objc dynamic var localLanguageId: Int = 0
    @objc dynamic var name = ""
    @objc dynamic var pokemonMoveMethodProseDescription: String = ""
}

class PokemonMoveMethod: Object, Identifiable {
    @objc dynamic var id = 0
    @objc dynamic var identifier = ""
    
    let prose = LinkingObjects(fromType: PokemonMoveMethodProse.self, property: "pokemonMoveMethod")
    let versions = LinkingObjects(fromType: VersionGroupPokemonMoveMethod.self, property: "pokemonMoveMethod")
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

// MARK: - PokemonMove
class PokemonMove: Object {
    @objc dynamic var pokemon: Pokemon?
    @objc dynamic var versionGroup: VersionGroup?
    @objc dynamic var move: Move?
    @objc dynamic var pokemonMoveMethod: PokemonMoveMethod?
    @objc dynamic var level: Int = 0
    let order = RealmOptional<Int>()
    
    var name: String {
        return move!.names.first(where: {$0.localLanguageId == 9})!.name
    }
    
    func machineName(for versionGroup: VersionGroup) -> String?  {
        if let machine = move!.machines.first(where: {$0.versionGroup?.id == versionGroup.id}) {
            return machine.item!.name
        }
        
        return nil
    }
}

// MARK: - PokemonShapeProse
class PokemonShapeProse: Object {
    @objc dynamic var pokemonShape: PokemonShape?
    @objc dynamic var localLanguageId: Int = 0
    @objc dynamic var name = ""
    @objc dynamic var awesomeName = ""
    @objc dynamic var pokemonShapeProseDescription: String = ""
}

// MARK: - PokemonShape
class PokemonShape: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var identifier: String = ""
    
    let prose = LinkingObjects(fromType: PokemonShapeProse.self, property: "pokemonShape")
    let pokemon = LinkingObjects(fromType: PokemonSpecies.self, property: "shape")
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

// MARK: - PokemonSpeciesName
class PokemonSpeciesName: Object {
    @objc dynamic var pokemonSpecies: PokemonSpecies?
    @objc dynamic var localLanguageId: Int = 0
    @objc dynamic var name = ""
    @objc dynamic var genus: String = ""
}

// MARK: - PokemonSpeciesFlavorText
class PokemonSpeciesFlavorText: Object {
    @objc dynamic var species: PokemonSpecies?
    @objc dynamic var version: Version?
    @objc dynamic var languageId: Int = 0
    @objc dynamic var flavorText: String = ""
}

// MARK: - PokemonSpeciesProse
class PokemonSpeciesProse: Object {
    @objc dynamic var pokemonSpecies: PokemonSpecies?
    @objc dynamic var localLanguageId: Int = 0
    @objc dynamic var formDescription: String = ""
}

// MARK: - PokemonSpecies
class PokemonSpecies: Object, Identifiable {
    @objc dynamic var id: Int = 0
    @objc dynamic var identifier: String = ""
    @objc dynamic var generation: Generation?
    @objc dynamic var evolvesFromSpeciesId: PokemonSpecies?
    @objc dynamic var evolutionChain: EvolutionChain?
    @objc dynamic var color: PokemonColor?
    @objc dynamic var shape: PokemonShape?
    @objc dynamic var habitat: PokemonHabitat?
    @objc dynamic var genderRate = 0
    @objc dynamic var captureRate = 0
    @objc dynamic var baseHappiness = 0
    @objc dynamic var isBaby = false
    @objc dynamic var hatchCounter = 0
    @objc dynamic var hasGenderDifferences = false
    @objc dynamic var growthRate: GrowthRate?
    @objc dynamic var formsSwitchable = false
    @objc dynamic var isLegendary = false
    @objc dynamic var isMythical = false
    @objc dynamic var order: Int = 0
    let conquestOrder = RealmOptional<Int>()
    
    let pokemonEvolution = LinkingObjects(fromType: PokemonEvolution.self, property: "evolvedSpecies")
    let evolvesTo = LinkingObjects(fromType: PokemonSpecies.self, property: "evolvesFromSpeciesId")
    let pokemon = LinkingObjects(fromType: Pokemon.self, property: "species")
    let prose = LinkingObjects(fromType: PokemonSpeciesProse.self, property: "pokemonSpecies")
    let flavorText = LinkingObjects(fromType: PokemonSpeciesFlavorText.self, property: "species")
    let names = LinkingObjects(fromType: PokemonSpeciesName.self, property: "pokemonSpecies")
    let eggGroups = LinkingObjects(fromType: PokemonEggGroup.self, property: "species")
    let dexNumbers = LinkingObjects(fromType: PokemonDexNumber.self, property: "species")
    let palParkAreas = LinkingObjects(fromType: PalParkAreaSpecies.self, property: "species")
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    var defaultForm: Pokemon {
        return pokemon.first(where: {$0.isDefault})!
    }
    
    func pokemonForm(for region: Region?) -> Pokemon {
        guard let region = region else {
            return defaultForm
        }
        
        guard let regionForm = pokemon.first(where: {$0.identifier == "\(identifier)-\(region.identifier)"}) else {
            return defaultForm
        }
        
        return regionForm
    }
    
    var name: String {
        return names.first(where: {$0.localLanguageId == 9})?.name ?? identifier
    }
}

// MARK: - PokemonStat
class PokemonStat: Object {
    @objc dynamic var pokemon: Pokemon?
    @objc dynamic var stat: Stat?
    @objc dynamic var baseStat = 0
    @objc dynamic var effort: Int = 0
}

// MARK: - PokemonType
class PokemonType: Object {
    @objc dynamic var pokemon: Pokemon?
    @objc dynamic var type: Type?
    @objc dynamic var slot: Int = 0
}

// MARK: - Pokemon
class Pokemon: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var identifier: String = ""
    @objc dynamic var species: PokemonSpecies?
    @objc dynamic var height = 0
    @objc dynamic var weight = 0
    @objc dynamic var baseExperience: Int = 0
    let order = RealmOptional<Int>()
    @objc dynamic var isDefault: Bool = false
    
    let types = LinkingObjects(fromType: PokemonType.self, property: "pokemon")
    let stats = LinkingObjects(fromType: PokemonStat.self, property: "pokemon")
    let moves = LinkingObjects(fromType: PokemonMove.self, property: "pokemon")
    let items = LinkingObjects(fromType: PokemonItem.self, property: "pokemon")
    let versionGameIndices = LinkingObjects(fromType: PokemonGameIndex.self, property: "pokemon")
    let forms = LinkingObjects(fromType: PokemonForm.self, property: "pokemon")
    let abilities = LinkingObjects(fromType: PokemonAbility.self, property: "pokemon")
    let encounters = LinkingObjects(fromType: Encounter.self, property: "pokemon")
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    var color: Color {
        return types.first(where: {$0.slot == 1})!.type!.color
    }
    
    var name: String {
        let formNameAlt = defaultForm.names.first(where: {$0.localLanguageId == 9})?.pokemonName ?? defaultForm.identifier
        let speciesName = species!.names.first(where: {$0.localLanguageId == 9})?.name ?? identifier
        
        return formNameAlt.isEmpty ? speciesName : formNameAlt
    }
    
    var defaultForm: PokemonForm {
        return forms.first(where: {$0.isDefault})!
    }
    
    var defaultFormName: String {
        let formName = forms.first(where: {$0.isDefault})!.names.first(where: {$0.localLanguageId == 9})?.formName ?? ""
        if formName.isEmpty { return "Normal"}
        return formName
    }
    
    var spriteImageLink: String {
        let link = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(species!.id)\(defaultForm.formIdentifier.isEmpty ? "" : "-\(defaultForm.formIdentifier)").png"
        return link
    }
}

// MARK: - RegionName
class RegionName: Object {
    @objc dynamic var region: Region?
    @objc dynamic var localLanguageId: Int = 0
    @objc dynamic var name: String = ""
}

// MARK: - Region
class Region: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var identifier: String = ""
    
    let names = LinkingObjects(fromType: RegionName.self, property: "region")
    let versionGroups = LinkingObjects(fromType: VersionGroupRegion.self, property: "region")
    let locations = LinkingObjects(fromType: Location.self, property: "region")
    let generations = LinkingObjects(fromType: Generation.self, property: "mainRegion")
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

// MARK: - StatName
class StatName: Object {
    @objc dynamic var stat: Stat?
    @objc dynamic var localLanguageId: Int = 0
    @objc dynamic var name: String = ""
}

// MARK: - Stat
class Stat: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var damageClass: MoveDamageClass?
    @objc dynamic var identifier: String = ""
    @objc dynamic var isBattleOnly: Bool = false
    let gameIndex = RealmOptional<Int>()
    
    let names = LinkingObjects(fromType: StatName.self, property: "stat")
    let moveMetaStatChanges = LinkingObjects(fromType: MoveMetaStatChange.self, property: "stat")
    let characteristics = LinkingObjects(fromType: Characteristic.self, property: "stat")
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    var icon: Image {
        return Image("ev_icon_\(identifier)")
    }
    
    var color: Color {
        return Color("\(identifier)")
    }
}

// MARK: - SuperContestCombo
class SuperContestCombo: Object {
    @objc dynamic var firstMove: Move?
    @objc dynamic var secondMove: Move?
}

// MARK: - SuperContestEffectProse
class SuperContestEffectProse: Object {
    @objc dynamic var superContestEffect: SuperContestEffect?
    @objc dynamic var localLanguageId: Int = 0
    @objc dynamic var flavorText: String = ""
}

// MARK: - SuperContestEffect
class SuperContestEffect: Object {
    @objc dynamic var id = 0
    @objc dynamic var appeal: Int = 0
    
    let prose = LinkingObjects(fromType: SuperContestEffectProse.self, property: "superContestEffect")
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

// MARK: - TypeEfficacy
class TypeEfficacy: Object {
    @objc dynamic var damageType: Type?
    @objc dynamic var targetType: Type?
    @objc dynamic var damageFactor: Int = 0
}

// MARK: - TypeGameIndex
class TypeGameIndex: Object {
    @objc dynamic var type: Type?
    @objc dynamic var generation: Generation?
    @objc dynamic var gameIndex: Int = 0
}

// MARK: - TypeName
class TypeName: Object {
    @objc dynamic var type: Type?
    @objc dynamic var localLanguageId: Int = 0
    @objc dynamic var name: String = ""
}

// MARK: - Type
class Type: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var identifier: String = ""
    @objc dynamic var generation: Generation?
    @objc dynamic var damageClass: MoveDamageClass?
    let order = RealmOptional<Int>()
        
    let names = LinkingObjects(fromType: TypeName.self, property: "type")
    let gameIndices = LinkingObjects(fromType: TypeGameIndex.self, property: "type")
    let moves = LinkingObjects(fromType: Move.self, property: "type")
    
    var color: Color {
        return Color(identifier)
    }
    
    var icon: Image {
        return Image("icon_\(identifier)")
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    var name: String {
        return names.first(where: {$0.localLanguageId == 9})?.name ?? identifier
    }
    
    var typeData: TypeEffectiveness.TypeData {
        return TypeEffectiveness.TypeData(rawValue: id)!
    }
}

// MARK: - VersionGroupPokemonMoveMethod
class VersionGroupPokemonMoveMethod: Object {
    @objc dynamic var versionGroup: VersionGroup?
    @objc dynamic var pokemonMoveMethod: PokemonMoveMethod?
}

// MARK: - VersionGroupRegion
class VersionGroupRegion: Object {
    @objc dynamic var versionGroup: VersionGroup?
    @objc dynamic var region: Region?
}

class VersionGroup: Object {
    @objc dynamic var id = 0
    @objc dynamic var identifier = ""
    @objc dynamic var generation: Generation?
    @objc dynamic var order = 0
    
    let versionGroupRegions = LinkingObjects(fromType: VersionGroupRegion.self, property: "versionGroup")
    let pokemonMoveMethods = LinkingObjects(fromType: VersionGroupPokemonMoveMethod.self, property: "versionGroup")
    let versions = LinkingObjects(fromType: Version.self, property: "versionGroup")
    let pokedexes = LinkingObjects(fromType: PokedexVersionGroup.self, property: "versionGroup")
    let machines = LinkingObjects(fromType: Machine.self, property: "versionGroup")
    let encounterSlots = LinkingObjects(fromType: EncounterSlot.self, property: "versionGroup")
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

// MARK: - VersionName
class VersionName: Object {
    @objc dynamic var version: Version?
    @objc dynamic var localLanguageId: Int = 0
    @objc dynamic var name: String = ""
}

// MARK: - Version
class Version: Object, Identifiable {
    @objc dynamic var id = 0
    @objc dynamic var identifier: String = ""
    @objc dynamic var versionGroup: VersionGroup?
    
    let names = LinkingObjects(fromType: VersionName.self, property: "version")
    let pokemonGameIndices = LinkingObjects(fromType: PokemonGameIndex.self, property: "version")
    let encounters = LinkingObjects(fromType: Encounter.self, property: "version")
    
    var color: Color {
        return Color("\(identifier)_version")
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
