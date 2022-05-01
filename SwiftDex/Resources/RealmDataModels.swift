//
//  RealmDataModels.swift
//  SwiftDex
//
//  Created by Brian Corbin on 4/2/22.
//

// swiftlint:disable file_length

import Foundation
import Realm
import RealmSwift
import SwiftUI

class Ability: Object, Identifiable {
    @Persisted(primaryKey: true) var id = 0
    @Persisted var identifier = ""
    @Persisted var isMainSeries = false
    @Persisted var generation: Generation?

    let changelogs = LinkingObjects(fromType: AbilityChangelog.self, property: "ability")
    let names = LinkingObjects(fromType: AbilityName.self, property: "ability")
    let prose = LinkingObjects(fromType: AbilityProse.self, property: "ability")
    let pokemonWithAbility = LinkingObjects(fromType: PokemonAbility.self, property: "ability")

    var name: String {
        return names.first(where: { $0.localLanguageId == 9 })?.name ?? identifier
    }

    var shortEffect: String {
        return prose.first(where: { $0.localLanguageId == 9 })?.shortEffect ?? "No short effect"
    }

    var effect: String {
        return prose.first(where: { $0.localLanguageId == 9 })?.effect ?? "No effect"
    }
}

class AbilityChangelog: Object {
    @Persisted(primaryKey: true) var id = 0
    @Persisted var ability: Ability?
    @Persisted var changedInVersionGroup: VersionGroup?

    let prose = LinkingObjects(fromType: AbilityChangelogProse.self, property: "abilityChangelog")
}

class AbilityChangelogProse: Object {
    @Persisted var localLanguageId = 0
    @Persisted var effect = ""
    @Persisted var abilityChangelog: AbilityChangelog?
}

class AbilityFlavorText: Object {
    @Persisted var ability: Ability?
    @Persisted var versionGroup: VersionGroup?
    @Persisted var language: Language?
    @Persisted var flavorText: String
}

class AbilityName: Object {
    @Persisted var localLanguageId = 0
    @Persisted var name = ""
    @Persisted var ability: Ability?
}

class AbilityProse: Object {
    @Persisted var localLanguageId = 0
    @Persisted var shortEffect = ""
    @Persisted var effect = ""
    @Persisted var ability: Ability?
}

class Berry: Object {
    @Persisted(primaryKey: true) var id = 0
    @Persisted var item: Item?
    @Persisted var firmness: BerryFirmness?
    @Persisted var naturalGiftPower = 0
    @Persisted var naturalGiftType: Type?
    @Persisted var size = 0
    @Persisted var maxHarvest = 0
    @Persisted var growthTime = 0
    @Persisted var soilDryness = 0
    @Persisted var smoothness = 0

    let contestFlavors = LinkingObjects(fromType: BerryFlavor.self, property: "berry")
}

class BerryFirmness: Object {
    @Persisted(primaryKey: true) var id = 0
    @Persisted var identifier = ""

    let names = LinkingObjects(fromType: BerryFirmnessName.self, property: "berryFirmness")
    let berriesWithFirmness = LinkingObjects(fromType: Berry.self, property: "firmness")
}

class BerryFirmnessName: Object {
    @Persisted var berryFirmness: BerryFirmness?
    @Persisted var localLanguageId = 0
    @Persisted var name: String = ""
}

class BerryFlavor: Object {
    @Persisted var berry: Berry?
    @Persisted var contestType: ContestType?
    @Persisted var flavor: Int
}

class Characteristic: Object {
    @Persisted(primaryKey: true) var id = 0
    @Persisted var stat: Stat?
    @Persisted var geneMod5 = 0

    let characteristicText = LinkingObjects(fromType: CharacteristicText.self, property: "characteristic")
}

class CharacteristicText: Object {
    @Persisted var characteristic: Characteristic?
    @Persisted var localLanguageId = 0
    @Persisted var message = ""
}

class ContestCombo: Object {
    @Persisted var firstMove: Move?
    @Persisted var secondMove: Move?
}


class ContestEffectProse: Object {
    @Persisted var contestEffect: ContestEffect?
    @Persisted var localLanguageId = 0
    @Persisted var flavorText = ""
    @Persisted var effect = ""
}

class ContestEffect: Object {
    @Persisted(primaryKey: true) var id = 0
    @Persisted var appeal = 0
    @Persisted var jam = 0

    let prose = LinkingObjects(fromType: ContestEffectProse.self, property: "contestEffect")
}

class ContestTypeName: Object {
    @Persisted var contestType: ContestType?
    @Persisted var localLanguageId = 0
    @Persisted var name = ""
    @Persisted var flavor = ""
    @Persisted var color = ""
}

class ContestType: Object {
    @Persisted(primaryKey: true) var id = 0
    @Persisted var identifier = ""

    let berryFlavorValues = LinkingObjects(fromType: BerryFlavor.self, property: "contestType")
    let names = LinkingObjects(fromType: ContestTypeName.self, property: "contestType")
    let moves = LinkingObjects(fromType: Move.self, property: "contestType")
}

class EggGroupProse: Object {
    @Persisted var eggGroup: EggGroup?
    @Persisted var localLanguageId = 0
    @Persisted var name: String = ""
}

class EggGroup: Object, Identifiable {
    @Persisted(primaryKey: true) var id = 0
    @Persisted var identifier = ""

    let prose = LinkingObjects(fromType: EggGroupProse.self, property: "eggGroup")

    var name: String {
        return prose.first(where: { $0.localLanguageId == 9 })?.name ?? identifier
    }
}

class EncounterConditionProse: Object {
    @Persisted var encounterCondition: EncounterCondition?
    @Persisted var localLanguageId: Int = 0
    @Persisted var name: String = ""
}

class EncounterConditionValueMap: Object {
    @Persisted var encounter: Encounter?
    @Persisted var encounterConditionValue: EncounterConditionValue?
}

class EncounterConditionValueProse: Object {
    @Persisted var encounterConditionValue: EncounterConditionValue?
    @Persisted var localLanguageId: Int = 0
    @Persisted var name: String = ""
}

class EncounterConditionValue: Object {
    @Persisted(primaryKey: true) var id = 0
    @Persisted var encounterCondition: EncounterCondition?
    @Persisted var identifier: String = ""
    @Persisted var isDefault = false

    let prose = LinkingObjects(fromType: EncounterConditionValueProse.self, property: "encounterConditionValue")
    let encounters = LinkingObjects(fromType: EncounterConditionValueMap.self, property: "encounterConditionValue")
}

class EncounterCondition: Object {
    @Persisted(primaryKey: true) var id = 0
    @Persisted var identifier = ""

    let prose = LinkingObjects(fromType: EncounterConditionProse.self, property: "encounterCondition")
    let encounterConditionValues = LinkingObjects(fromType: EncounterConditionValue.self, property: "encounterCondition")
}

class EncounterMethodProse: Object {
    @Persisted var encounterMethod: EncounterMethod?
    @Persisted var localLanguageId: Int = 0
    @Persisted var name: String = ""
}

class EncounterMethod: Object {
    @Persisted(primaryKey: true) var id: Int = 0
    @Persisted var identifier: String = ""
    @Persisted var order: Int = 0

    let prose = LinkingObjects(fromType: EncounterMethodProse.self, property: "encounterMethod")
    let encounterSlots = LinkingObjects(fromType: EncounterSlot.self, property: "encounterMethod")
}

class EncounterSlot: Object {
    @Persisted(primaryKey: true) var id = 0
    @Persisted var versionGroup: VersionGroup?
    @Persisted var encounterMethod: EncounterMethod?
    @Persisted var slot: Int?
    @Persisted var rarity: Int = 0

    let encounters = LinkingObjects(fromType: Encounter.self, property: "encounterSlot")
}

class Encounter: Object {
    @Persisted(primaryKey: true) var id = 0
    @Persisted var version: Version?
    @Persisted var locationArea: LocationArea?
    @Persisted var encounterSlot: EncounterSlot?
    @Persisted var pokemon: Pokemon?
    @Persisted var minLevel = 0
    @Persisted var maxLevel: Int = 0

    let encounterConditions = LinkingObjects(fromType: EncounterConditionValueMap.self, property: "encounter")
}

class EvolutionChain: Object {
    @Persisted(primaryKey: true) var id: Int = 0
    @Persisted var babyTriggerItem: Item?

    let pokemonInChain = LinkingObjects(fromType: Pokemon.self, property: "evolutionChain")
}

class EvolutionTriggerProse: Object {
    @Persisted var evolutionTrigger: EvolutionTrigger?
    @Persisted var localLanguageId: Int = 0
    @Persisted var name: String = ""
}

class EvolutionTrigger: Object {
    @Persisted(primaryKey: true) var id = 0
    @Persisted var identifier = ""

    let prose = LinkingObjects(fromType: EvolutionTriggerProse.self, property: "evolutionTrigger")
    
    var name: String {
        return prose.first(where: { $0.localLanguageId == 9 })?.name ?? identifier
    }
}

class Experience: Object {
    @Persisted var growthRate: GrowthRate?
    @Persisted var level = 0
    @Persisted var experience: Int = 0
}

class Gender: Object {
    @Persisted(primaryKey: true) var id = 0
    @Persisted var identifier = ""

    var name: String {
        return identifier
    }
}

class GenerationName: Object {
    @Persisted var generation: Generation?
    @Persisted var localLanguageId: Int = 0
    @Persisted var name: String = ""
}

class Generation: Object, Identifiable {
    @Persisted(primaryKey: true) var id = 0
    @Persisted var mainRegion: Region?
    @Persisted var identifier: String = ""

    let versionGroups = LinkingObjects(fromType: VersionGroup.self, property: "generation")
    let moves = LinkingObjects(fromType: Move.self, property: "generation")
    let locationGameIndices = LinkingObjects(fromType: LocationGameIndex.self, property: "generation")
    let itemGameIndices = LinkingObjects(fromType: ItemGameIndex.self, property: "generation")
    let names = LinkingObjects(fromType: GenerationName.self, property: "generation")
    let abilities = LinkingObjects(fromType: Ability.self, property: "generation")

    var name: String {
        return names.first(where: { $0.localLanguageId == 9 })?.name ?? identifier
    }
}

class GrowthRateProse: Object {
    @Persisted var growthRate: GrowthRate?
    @Persisted var localLanguageId: Int = 0
    @Persisted var name: String = ""
}

class GrowthRate: Object {
    @Persisted(primaryKey: true) var id: Int = 0
    @Persisted var identifier = ""
    @Persisted var formula: String = ""

    let prose = LinkingObjects(fromType: GrowthRateProse.self, property: "growthRate")
    let experienceForLevels = LinkingObjects(fromType: Experience.self, property: "growthRate")
    
    var name: String {
        return prose.first(where: { $0.localLanguageId == 9 })?.name ?? identifier
    }
}

class ItemCategory: Object {
    @Persisted(primaryKey: true) var id = 0
    @Persisted var pocket: ItemPocket?
    @Persisted var identifier: String = ""

    let items = LinkingObjects(fromType: Item.self, property: "category")
    let prose = LinkingObjects(fromType: ItemCategoryProse.self, property: "itemCategory")
    
    var name: String {
        return prose.first(where: { $0.localLanguageId == 9 })?.name ?? identifier
    }
}

class ItemCategoryProse: Object {
    @Persisted var itemCategory: ItemCategory?
    @Persisted var localLanguageId: Int = 0
    @Persisted var name: String = ""
}

class ItemFlagMap: Object {
    @Persisted var item: Item?
    @Persisted var itemFlag: ItemFlag?
}

class ItemFlagProse: Object {
    @Persisted var itemFlag: ItemFlag?
    @Persisted var localLanguageId: Int = 0
    @Persisted var name = ""
    @Persisted var itemFlagProseDescription: String = ""
}

class ItemFlag: Object {
    @Persisted(primaryKey: true) var id = 0
    @Persisted var identifier = ""

    let prose = LinkingObjects(fromType: ItemFlagProse.self, property: "itemFlag")
}

class Item: Object, Identifiable {
    @Persisted(primaryKey: true) var id: Int = 0
    @Persisted var identifier: String = ""
    @Persisted var category: ItemCategory?
    @Persisted var cost: Int = 0
    @Persisted var flingPower: Int?
    @Persisted var flingEffect: ItemFlingEffect?

    let machines = LinkingObjects(fromType: Machine.self, property: "item")
    let names = LinkingObjects(fromType: ItemName.self, property: "item")
    let prose = LinkingObjects(fromType: ItemProse.self, property: "item")
    let gameIndices = LinkingObjects(fromType: ItemGameIndex.self, property: "item")
    let flavorTexts = LinkingObjects(fromType: ItemFlavorText.self, property: "item")
    let flags = LinkingObjects(fromType: ItemFlagMap.self, property: "item")

    var name: String {
        return names.first(where: { $0.localLanguageId == 9 })?.name ?? identifier
    }

    var sprite: Image {
        return Image("sprites/items/\(identifier)")
    }

    func flavorText(for versionGroup: VersionGroup?) -> String {
        return flavorTexts.first(where: { $0.languageId == 9 && $0.versionGroup!.id == versionGroup?.id ?? 18 })?.flavorText?.replacingOccurrences(of: "\n", with: " ") ?? "No Flavor Text"
    }

    var effectText: String {
        return prose.first(where: { $0.localLanguageId == 9 })?.effect ?? "No item effect"
    }

    var shortEffectText: String {
        return prose.first(where: { $0.localLanguageId == 9 })?.shortEffect ?? "No short effect text"
    }
}

class ItemFlavorText: Object {
    @Persisted var item: Item?
    @Persisted var versionGroup: VersionGroup?
    @Persisted var languageId: Int = 0
    @Persisted var flavorText: String?
}

class ItemFlingEffect: Object {
    @Persisted(primaryKey: true) var id = 0
    @Persisted var identifier = ""

    let prose = LinkingObjects(fromType: ItemFlingEffectProse.self, property: "itemFlingEffect")

    var effect: String {
        return prose.first(where: { $0.localLanguageId == 9 })?.effect ?? identifier
    }
}

class ItemFlingEffectProse: Object {
    @Persisted var itemFlingEffect: ItemFlingEffect?
    @Persisted var localLanguageId: Int = 0
    @Persisted var effect: String = ""
}

class ItemGameIndex: Object {
    @Persisted var item: Item?
    @Persisted var generation: Generation?
    @Persisted var gameIndex: Int = 0
}

class ItemName: Object {
    @Persisted var item: Item?
    @Persisted var localLanguageId: Int = 0
    @Persisted var name: String = ""
}

class ItemPocketName: Object {
    @Persisted var itemPocket: ItemPocket?
    @Persisted var localLanguageId: Int = 0
    @Persisted var name: String = ""
}

class ItemPocket: Object, Identifiable {
    @Persisted(primaryKey: true) var id = 0
    @Persisted var identifier = ""

    let itemCategories = LinkingObjects(fromType: ItemCategory.self, property: "pocket")
    let names = LinkingObjects(fromType: ItemPocketName.self, property: "itemPocket")

    var name: String {
        return names.first(where: { $0.localLanguageId == 9 })?.name ?? identifier
    }
}

class ItemProse: Object {
    @Persisted var item: Item?
    @Persisted var localLanguageId: Int
    @Persisted var shortEffect: String?
    @Persisted var effect: String?
}

class Language: Object {
    @Persisted(primaryKey: true) var id = 0
    @Persisted var iso639 = ""
    @Persisted var iso3166 = ""
    @Persisted var identifier = ""
    @Persisted var official = 0
    @Persisted var order = 0

    let names = LinkingObjects(fromType: LanguageName.self, property: "language")
}

class LanguageName: Object {
    @Persisted var language: Language?
    @Persisted var localLanguage: Language?
    @Persisted var name = ""
}

class LocationAreaEncounterRate: Object {
    @Persisted var locationArea: LocationArea?
    @Persisted var encounterMethod: EncounterMethod?
    @Persisted var version: Version?
    @Persisted var rate = 0
}

class LocationAreaProse: Object {
    @Persisted var locationArea: LocationArea?
    @Persisted var localLanguageId: Int = 0
    @Persisted var name: String?
}

class LocationArea: Object {
    @Persisted(primaryKey: true) var id = 0
    @Persisted var location: Location?
    @Persisted var gameIndex: Int = 0
    @Persisted var identifier: String?

    let prose = LinkingObjects(fromType: LocationAreaProse.self, property: "locationArea")
    let encounterRates = LinkingObjects(fromType: LocationAreaEncounterRate.self, property: "locationArea")
    let encounters = LinkingObjects(fromType: Encounter.self, property: "locationArea")
}

class LocationGameIndex: Object {
    @Persisted var location: Location?
    @Persisted var generation: Generation?
    @Persisted var gameIndex: Int = 0
}

class LocationName: Object {
    @Persisted var location: Location?
    @Persisted var localLanguageId: Int
    @Persisted var name: String?
    @Persisted var subtitle: String?
}

class Location: Object {
    @Persisted(primaryKey: true) var id: Int = 0
    @Persisted var region: Region?
    @Persisted var identifier: String = ""

    let names = LinkingObjects(fromType: LocationName.self, property: "location")
    let gameIndices = LinkingObjects(fromType: LocationGameIndex.self, property: "location")
    let areas = LinkingObjects(fromType: LocationArea.self, property: "location")
    
    var name: String {
        return names.first(where: { $0.localLanguageId == 9 })?.name ?? identifier
    }
}

class Machine: Object {
    @Persisted var machineNumber = 0
    @Persisted var versionGroup: VersionGroup?
    @Persisted var item: Item?
    @Persisted var move: Move?
}

class MoveBattleStyleProse: Object {
    @Persisted var moveBattleStyle: MoveBattleStyle?
    @Persisted var localLanguageId: Int = 0
    @Persisted var name: String = ""
}

class MoveBattleStyle: Object {
    @Persisted(primaryKey: true) var id = 0
    @Persisted var identifier = ""

    let prose = LinkingObjects(fromType: MoveBattleStyleProse.self, property: "moveBattleStyle")
    let naturePreferences = LinkingObjects(fromType: NatureBattleStylePreference.self, property: "moveBattleStyle")
}

class Move: Object, Identifiable {
    @Persisted(primaryKey: true) var id: Int = 0
    @Persisted var identifier: String = ""
    @Persisted var generation: Generation?
    @Persisted var type: Type?
    @Persisted var damageClass: MoveDamageClass?
    @Persisted var target: MoveTarget?
    @Persisted var power: Int?
    @Persisted var pp: Int?
    @Persisted var accuracy: Int?
    @Persisted var priority: Int = 0
    @Persisted var effect: MoveEffect?
    @Persisted var effectChance: Int?
    @Persisted var contestType: ContestType?
    @Persisted var contestEffect: ContestEffect?
    @Persisted var superContestEffect: SuperContestEffect?

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
    let pokemonMoves = LinkingObjects(fromType: PokemonMove.self, property: "move")

    var name: String {
        return names.first(where: { $0.localLanguageId == 9 })?.name ?? identifier
    }
}

class MoveChangelog: Object {
    @Persisted var move: Move?
    @Persisted var changedInVersionGroup: VersionGroup?
    @Persisted var type: Type?
    @Persisted var power: Int?
    @Persisted var pp: Int?
    @Persisted var accuracy: Int?
    @Persisted var priority: Int?
    @Persisted var target: MoveTarget?
    @Persisted var effect: MoveEffect?
    @Persisted var effectChance: Int?
}

class MoveDamageClass: Object, Identifiable {
    @Persisted(primaryKey: true) var id = 0
    @Persisted var identifier = ""

    let prose = LinkingObjects(fromType: MoveDamageClassProse.self, property: "moveDamageClass")

    var name: String {
        return prose.first(where: { $0.localLanguageId == 9 })?.name ?? identifier
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
    @Persisted var moveDamageClass: MoveDamageClass?
    @Persisted var localLanguageId = 0
    @Persisted var name = ""
    @Persisted var moveProseDescription = ""
}

class MoveEffectChangelogProse: Object {
    @Persisted var moveEffectChangelog: MoveEffectChangelog?
    @Persisted var localLanguageId: Int = 0
    @Persisted var effect: String = ""
}

class MoveEffectChangelog: Object {
    @Persisted(primaryKey: true) var id = 0
    @Persisted var effect: MoveEffect?
    @Persisted var changedInVersionGroup: VersionGroup?

    let prose = LinkingObjects(fromType: MoveEffectChangelogProse.self, property: "moveEffectChangelog")
}

class MoveEffectProse: Object {
    @Persisted var moveEffect: MoveEffect?
    @Persisted var localLanguageId: Int = 0
    @Persisted var shortEffect: String = ""
    @Persisted var effect: String = ""
}

class MoveEffect: Object {
    @Persisted(primaryKey: true) var id: Int = 0

    let prose = LinkingObjects(fromType: MoveEffectProse.self, property: "moveEffect")
    let changelogs = LinkingObjects(fromType: MoveEffectChangelog.self, property: "effect")

    var shortEffectDescription: String {
        return prose.first(where: { $0.localLanguageId == 9 })?.shortEffect ?? "No short effect"
    }

    var effectDescription: String {
        return prose.first(where: { $0.localLanguageId == 9 })?.effect ?? "No effect description"
    }
}

class MoveFlagMap: Object {
    @Persisted var move: Move?
    @Persisted var moveFlag: MoveFlag?
}

class MoveFlagProse: Object {
    @Persisted var moveFlag: MoveFlag?
    @Persisted var localLanguageId = 0
    @Persisted var name = ""
    @Persisted var moveProseDescription = ""
}

class MoveFlag: Object {
    @Persisted(primaryKey: true) var id = 0
    @Persisted var identifier = ""

    let prose = LinkingObjects(fromType: MoveFlagProse.self, property: "moveFlag")
    let moves = LinkingObjects(fromType: MoveFlagMap.self, property: "moveFlag")
}

class MoveFlavorText: Object {
    @Persisted var move: Move?
    @Persisted var versionGroup: VersionGroup?
    @Persisted var languageId: Int
    @Persisted var flavorText: String
}

class MoveMetaAilmentName: Object {
    @Persisted var moveMetaAilment: MoveMetaAilment?
    @Persisted var localLanguageId: Int = 0
    @Persisted var name: String = ""
}

class MoveMetaAilment: Object {
    @Persisted(primaryKey: true) var id = 0
    @Persisted var identifier = ""

    let names = LinkingObjects(fromType: MoveMetaAilmentName.self, property: "moveMetaAilment")
}

class MoveMetaCategory: Object {
    @Persisted(primaryKey: true) var id = 0
    @Persisted var identifier = ""

    let prose = LinkingObjects(fromType: MoveMetaCategoryProse.self, property: "moveMetaCategory")
}

class MoveMetaCategoryProse: Object {
    @Persisted var moveMetaCategory: MoveMetaCategory?
    @Persisted var localLanguageId: Int = 0
    @Persisted var moveMetaCategoryProseDescription: String = ""
}

class MoveMetaStatChange: Object {
    @Persisted var move: Move?
    @Persisted var stat: Stat?
    @Persisted var change: Int = 0
}

class MoveMeta: Object {
    @Persisted var move: Move?
    @Persisted var metaCategory: MoveMetaCategory? //
    @Persisted var metaAilment: MoveMetaAilment? //
    @Persisted var minHits: Int?
    @Persisted var maxHits: Int?
    @Persisted var minTurns: Int?
    @Persisted var maxTurns: Int?
    @Persisted var drain = 0
    @Persisted var healing = 0
    @Persisted var critRate = 0
    @Persisted var ailmentChance = 0
    @Persisted var flinchChance = 0
    @Persisted var statChance = 0
}

class MoveName: Object {
    @Persisted var move: Move?
    @Persisted var localLanguageId: Int = 0
    @Persisted var name: String = ""
}

class MoveTargetProse: Object {
    @Persisted var moveTarget: MoveTarget?
    @Persisted var localLanguageId: Int = 0
    @Persisted var name: String = ""
    @Persisted var targetDescription: String = ""
}

class MoveTarget: Object {
    @Persisted(primaryKey: true) var id = 0
    @Persisted var identifier = ""

    let prose = LinkingObjects(fromType: MoveTargetProse.self, property: "moveTarget")

    var name: String {
        return prose.first(where: { $0.localLanguageId == 9 })?.name ?? identifier
    }

    var targetDescription: String {
        return prose.first(where: { $0.localLanguageId == 9 })?.targetDescription ?? "No target description"
    }
}

class NatureBattleStylePreference: Object {
    @Persisted var nature: Nature?
    @Persisted var moveBattleStyle: MoveBattleStyle?
    @Persisted var lowHPPreference = false
    @Persisted var highHPPreference = false
}

class NatureName: Object {
    @Persisted var nature: Nature?
    @Persisted var localLanguageId: Int = 0
    @Persisted var name: String = ""
}

class NaturePokeathlonStat: Object {
    @Persisted var nature: Nature?
    @Persisted var pokeathlonStat: PokeathlonStat?
    @Persisted var maxChange: Int = 0
}

class Nature: Object, Identifiable {
    @Persisted(primaryKey: true) var id: Int = 0
    @Persisted var identifier: String = ""
    @Persisted var decreasedStat: Stat?
    @Persisted var increasedStat: Stat?
    @Persisted var hatesFlavor: ContestType?
    @Persisted var likesFlavor: ContestType?
    @Persisted var gameIndex: Int = 0

    let pokeathlonStatChanges = LinkingObjects(fromType: NaturePokeathlonStat.self, property: "nature")
    let names = LinkingObjects(fromType: NatureName.self, property: "nature")
    let moveBattleStylePreferences = LinkingObjects(fromType: NatureBattleStylePreference.self, property: "nature")

    var name: String {
        return names.first(where: { $0.localLanguageId == 9 })?.name ?? identifier
    }
}

class PalParkAreaName: Object {
    @Persisted var palParkArea: PalParkArea?
    @Persisted var localLanguageId: Int = 0
    @Persisted var name: String = ""
}

class PalParkArea: Object {
    @Persisted(primaryKey: true) var id: Int = 0
    @Persisted var identifier: String = ""

    let names = LinkingObjects(fromType: PalParkAreaName.self, property: "palParkArea")
    let species = LinkingObjects(fromType: PalParkAreaSpecies.self, property: "area")
}

class PalParkAreaSpecies: Object {
    @Persisted var species: PokemonSpecies?
    @Persisted var area: PalParkArea?
    @Persisted var baseScore = 0
    @Persisted var rate: Int = 0
}

class PokeathlonStatName: Object {
    @Persisted var pokeathlonStat: PokeathlonStat?
    @Persisted var localLanguageId: Int = 0
    @Persisted var name: String = ""
}

class PokeathlonStat: Object {
    @Persisted(primaryKey: true) var id: Int = 0
    @Persisted var identifier: String = ""

    let names = LinkingObjects(fromType: PokeathlonStatName.self, property: "pokeathlonStat")
    let changeFromNatures = LinkingObjects(fromType: NaturePokeathlonStat.self, property: "pokeathlonStat")
}

class PokedexProse: Object {
    @Persisted var pokedex: Pokedex?
    @Persisted var localLanguageId: Int = 0
    @Persisted var name = ""
    @Persisted var pokedexProseDescription: String
}

class PokedexVersionGroup: Object {
    @Persisted var pokedex: Pokedex?
    @Persisted var versionGroup: VersionGroup?
}

class Pokedex: Object, Identifiable {
    @Persisted(primaryKey: true) var id: Int = 0
    @Persisted var region: Region?
    @Persisted var identifier: String = ""
    @Persisted var isMainSeries = false

    let pokemonSpeciesDexNumbers = LinkingObjects(fromType: PokemonDexNumber.self, property: "pokedex")
    let versionGroups = LinkingObjects(fromType: PokedexVersionGroup.self, property: "pokedex")
    let prose = LinkingObjects(fromType: PokedexProse.self, property: "pokedex")

    var name: String {
        return prose.first(where: { $0.localLanguageId == 9 })?.name
            .replacingOccurrences(of: "Updated ", with: "")
            .replacingOccurrences(of: "Original ", with: "")
            .replacingOccurrences(of: "Extended ", with: "")
            .replacingOccurrences(of: "New ", with: "") ?? identifier
    }
}

class PokemonAbility: Object {
    @Persisted var pokemon: Pokemon?
    @Persisted var ability: Ability?
    @Persisted var isHidden = false
    @Persisted var slot = 0
}

class PokemonColorName: Object {
    @Persisted var pokemonColor: PokemonColor?
    @Persisted var localLanguageId: Int = 0
    @Persisted var name: String = ""
}

class PokemonColor: Object {
    @Persisted(primaryKey: true) var id: Int = 0
    @Persisted var identifier: String = ""

    let names = LinkingObjects(fromType: PokemonColorName.self, property: "pokemonColor")
    let speciesWithColor = LinkingObjects(fromType: PokemonSpecies.self, property: "color")
}

class PokemonDexNumber: Object, Identifiable {
    @Persisted var species: PokemonSpecies?
    @Persisted var pokedex: Pokedex?
    @Persisted var pokedexNumber: Int = 0

    var id: String {
        return "\(pokedex!.id)-\(pokedexNumber)-\(species!.id)"
    }
}

class PokemonEggGroup: Object {
    @Persisted var species: PokemonSpecies?
    @Persisted var eggGroup: EggGroup?
}

class PokemonEvolution: Object {
    @Persisted(primaryKey: true) var id = 0
    @Persisted var evolvedSpecies: PokemonSpecies?
    @Persisted var evolutionTrigger: EvolutionTrigger?
    @Persisted var triggerItem: Item?
    @Persisted var minimumLevel: Int?
    @Persisted var gender: Gender?
    @Persisted var location: Location?
    @Persisted var heldItem: Item?
    @Persisted var timeOfDay: String?
    @Persisted var knownMove: Move?
    @Persisted var knownMoveType: Type?
    @Persisted var minimumHappiness: Int?
    @Persisted var minimumBeauty: Int?
    @Persisted var minimumAffection: Int?
    @Persisted var relativePhysicalStats: Int?
    @Persisted var partySpecies: PokemonSpecies?
    @Persisted var partyType: Type?
    @Persisted var tradeSpecies: PokemonSpecies?
    @Persisted var needsOverworldRain = false
    @Persisted var turnUpsideDown = false
}

class PokemonFormGeneration: Object {
    @Persisted var pokemonForm: PokemonForm?
    @Persisted var generation: Generation?
    @Persisted var gameIndex: Int = 0
}

class PokemonFormName: Object {
    @Persisted var pokemonForm: PokemonForm?
    @Persisted var localLanguageId: Int
    @Persisted var formName: String?
    @Persisted var pokemonName: String?
}

class PokemonFormPokeathlonStat: Object {
    @Persisted var pokemonForm: PokemonForm?
    @Persisted var pokeathlonStat: PokeathlonStat?
    @Persisted var minimumStat = 0
    @Persisted var baseStat: Int = 0
    @Persisted var maximumStat: Int = 0
}

class PokemonFormType: Object {
    @Persisted var pokemonForm: PokemonForm?
    @Persisted var type: Type?
    @Persisted var slot: Int
}

class PokemonForm: Object {
    @Persisted(primaryKey: true) var id: Int = 0
    @Persisted var identifier: String
    @Persisted var formIdentifier: String?
    @Persisted var pokemon: Pokemon?
    @Persisted var introducedInVersionGroup: VersionGroup?
    @Persisted var isDefault = false
    @Persisted var isBattleOnly = false
    @Persisted var isMega = false
    @Persisted var formOrder = 0
    @Persisted var order: Int = 0

    let names = LinkingObjects(fromType: PokemonFormName.self, property: "pokemonForm")
    let generations = LinkingObjects(fromType: PokemonFormGeneration.self, property: "pokemonForm")
    let pokeathlonStats = LinkingObjects(fromType: PokemonFormPokeathlonStat.self, property: "pokemonForm")
}

class PokemonGameIndex: Object {
    @Persisted var pokemon: Pokemon?
    @Persisted var version: Version?
    @Persisted var gameIndex: Int = 0
}

class PokemonHabitatName: Object {
    @Persisted var pokemonHabitat: PokemonHabitat?
    @Persisted var localLanguageId: Int = 0
    @Persisted var name: String = ""
}

class PokemonHabitat: Object {
    @Persisted(primaryKey: true) var id: Int = 0
    @Persisted var identifier: String = ""

    let names = LinkingObjects(fromType: PokemonHabitatName.self, property: "pokemonHabitat")
}

class PokemonItem: Object {
    @Persisted var pokemon: Pokemon?
    @Persisted var version: Version?
    @Persisted var item: Item?
    @Persisted var rarity: Int = 0
}

class PokemonMoveMethodProse: Object {
    @Persisted var pokemonMoveMethod: PokemonMoveMethod?
    @Persisted var localLanguageId: Int = 0
    @Persisted var name = ""
    @Persisted var pokemonMoveMethodProseDescription: String = ""
}

class PokemonMoveMethod: Object, Identifiable {
    @Persisted(primaryKey: true) var id = 0
    @Persisted var identifier = ""

    let prose = LinkingObjects(fromType: PokemonMoveMethodProse.self, property: "pokemonMoveMethod")
    let versions = LinkingObjects(fromType: VersionGroupPokemonMoveMethod.self, property: "pokemonMoveMethod")
}

class PokemonMove: Object {
    @Persisted var pokemon: Pokemon?
    @Persisted var versionGroup: VersionGroup?
    @Persisted var move: Move?
    @Persisted var pokemonMoveMethod: PokemonMoveMethod?
    @Persisted var level: Int
    @Persisted var order: Int?

    var name: String {
        return move!.names.first(where: { $0.localLanguageId == 9 })!.name
    }

    func machineName(for versionGroup: VersionGroup) -> String? {
        if let machine = move!.machines.first(where: { $0.versionGroup?.id == versionGroup.id }) {
            return machine.item!.name
        }

        return nil
    }
}

class PokemonShapeProse: Object {
    @Persisted var pokemonShape: PokemonShape?
    @Persisted var localLanguageId: Int = 0
    @Persisted var name = ""
    @Persisted var awesomeName = ""
    @Persisted var pokemonShapeProseDescription: String = ""
}

class PokemonShape: Object {
    @Persisted(primaryKey: true) var id: Int = 0
    @Persisted var identifier: String = ""

    let prose = LinkingObjects(fromType: PokemonShapeProse.self, property: "pokemonShape")
    let pokemon = LinkingObjects(fromType: PokemonSpecies.self, property: "shape")
}

class PokemonSpeciesName: Object {
    @Persisted var pokemonSpecies: PokemonSpecies?
    @Persisted var localLanguageId: Int = 0
    @Persisted var name = ""
    @Persisted var genus: String?
}

class PokemonSpeciesFlavorText: Object {
    @Persisted var species: PokemonSpecies?
    @Persisted var version: Version?
    @Persisted var languageId: Int = 0
    @Persisted var flavorText: String = ""
}

class PokemonSpeciesProse: Object {
    @Persisted var pokemonSpecies: PokemonSpecies?
    @Persisted var localLanguageId: Int = 0
    @Persisted var formDescription: String = ""
}

class PokemonSpecies: Object, Identifiable {
    @Persisted(primaryKey: true) var id: Int = 0
    @Persisted var identifier: String = ""
    @Persisted var generation: Generation?
    @Persisted var evolvesFromSpecies: PokemonSpecies?
    @Persisted var evolutionChain: EvolutionChain?
    @Persisted var color: PokemonColor?
    @Persisted var shape: PokemonShape?
    @Persisted var habitat: PokemonHabitat?
    @Persisted var genderRate = 0
    @Persisted var captureRate = 0
    @Persisted var baseHappiness = 0
    @Persisted var isBaby = false
    @Persisted var hatchCounter = 0
    @Persisted var hasGenderDifferences = false
    @Persisted var growthRate: GrowthRate?
    @Persisted var formsSwitchable = false
    @Persisted var isLegendary = false
    @Persisted var isMythical = false
    @Persisted var order: Int = 0

    let pokemon = LinkingObjects(fromType: Pokemon.self, property: "species")
    let prose = LinkingObjects(fromType: PokemonSpeciesProse.self, property: "pokemonSpecies")
    let flavorText = LinkingObjects(fromType: PokemonSpeciesFlavorText.self, property: "species")
    let names = LinkingObjects(fromType: PokemonSpeciesName.self, property: "pokemonSpecies")
    let eggGroups = LinkingObjects(fromType: PokemonEggGroup.self, property: "species")
    let palParkAreas = LinkingObjects(fromType: PalParkAreaSpecies.self, property: "species")
    
    var defaultForm: Pokemon {
        return pokemon.first(where: { $0.isDefault })!
    }

    func pokemonForm(for region: Region?) -> Pokemon {
        guard let region = region else {
            return defaultForm
        }

        guard let regionForm = pokemon.first(where: { $0.identifier == "\(identifier)-\(region.identifier)" }) else {
            return defaultForm
        }

        return regionForm
    }

    var name: String {
        return names.first(where: { $0.localLanguageId == 9 })?.name ?? identifier
    }
}

class PokemonStat: Object {
    @Persisted var pokemon: Pokemon?
    @Persisted var stat: Stat?
    @Persisted var baseStat = 0
    @Persisted var effort: Int = 0
}

class PokemonType: Object {
    @Persisted var pokemon: Pokemon?
    @Persisted var type: Type?
    @Persisted var slot: Int = 0
}

class PokemonTypePast: Object {
    @Persisted var pokemon: Pokemon?
    @Persisted var generation: Generation?
    @Persisted var type: Type?
    @Persisted var slot: Int
}

class Pokemon: Object, Identifiable {
    @Persisted(primaryKey: true) var id: Int = 0
    @Persisted var identifier: String
    @Persisted var species: PokemonSpecies?
    @Persisted var height: Int
    @Persisted var weight: Int
    @Persisted var baseExperience: Int
    @Persisted var order: Int?
    @Persisted var isDefault: Bool

    let types = LinkingObjects(fromType: PokemonType.self, property: "pokemon")
    let stats = LinkingObjects(fromType: PokemonStat.self, property: "pokemon")
    let moves = LinkingObjects(fromType: PokemonMove.self, property: "pokemon")
    let items = LinkingObjects(fromType: PokemonItem.self, property: "pokemon")
    let versionGameIndices = LinkingObjects(fromType: PokemonGameIndex.self, property: "pokemon")
    let forms = LinkingObjects(fromType: PokemonForm.self, property: "pokemon")
    let abilities = LinkingObjects(fromType: PokemonAbility.self, property: "pokemon")
    let encounters = LinkingObjects(fromType: Encounter.self, property: "pokemon")
    let dexNumbers = LinkingObjects(fromType: PokemonDexNumber.self, property: "pokemon")

    
}

class RegionName: Object {
    @Persisted var region: Region?
    @Persisted var localLanguageId: Int = 0
    @Persisted var name: String = ""
}

class Region: Object {
    @Persisted(primaryKey: true) var id: Int = 0
    @Persisted var identifier: String = ""

    let names = LinkingObjects(fromType: RegionName.self, property: "region")
    let versionGroups = LinkingObjects(fromType: VersionGroupRegion.self, property: "region")
    let locations = LinkingObjects(fromType: Location.self, property: "region")
    let generations = LinkingObjects(fromType: Generation.self, property: "mainRegion")
}

class StatName: Object {
    @Persisted var stat: Stat?
    @Persisted var localLanguageId: Int = 0
    @Persisted var name: String = ""
}

class Stat: Object {
    @Persisted(primaryKey: true) var id: Int = 0
    @Persisted var damageClass: MoveDamageClass?
    @Persisted var identifier: String = ""
    @Persisted var isBattleOnly = false
    @Persisted var gameIndex: Int?

    let names = LinkingObjects(fromType: StatName.self, property: "stat")
    let moveMetaStatChanges = LinkingObjects(fromType: MoveMetaStatChange.self, property: "stat")
    let characteristics = LinkingObjects(fromType: Characteristic.self, property: "stat")
}

class SuperContestCombo: Object {
    @Persisted var firstMove: Move?
    @Persisted var secondMove: Move?
}

class SuperContestEffectProse: Object {
    @Persisted var superContestEffect: SuperContestEffect?
    @Persisted var localLanguageId: Int = 0
    @Persisted var flavorText: String = ""
}

class SuperContestEffect: Object {
    @Persisted(primaryKey: true) var id = 0
    @Persisted var appeal: Int = 0

    let prose = LinkingObjects(fromType: SuperContestEffectProse.self, property: "superContestEffect")
}

class TypeEfficacy: Object {
    @Persisted var damageType: Type?
    @Persisted var targetType: Type?
    @Persisted var damageFactor: Int = 0
}

class TypeEfficacyPast: Object {
    @Persisted var damageType: Type?
    @Persisted var targetType: Type?
    @Persisted var damageFactor: Int
    @Persisted var generation: Generation?
}

class TypeGameIndex: Object {
    @Persisted var type: Type?
    @Persisted var generation: Generation?
    @Persisted var gameIndex: Int = 0
}

class TypeName: Object {
    @Persisted var type: Type?
    @Persisted var localLanguageId: Int = 0
    @Persisted var name: String = ""
}

class Type: Object {
    @Persisted(primaryKey: true) var id: Int = 0
    @Persisted var identifier: String = ""
    @Persisted var generation: Generation?
    @Persisted var damageClass: MoveDamageClass?

    let names = LinkingObjects(fromType: TypeName.self, property: "type")
    let gameIndices = LinkingObjects(fromType: TypeGameIndex.self, property: "type")
    let moves = LinkingObjects(fromType: Move.self, property: "type")
}

class VersionGroupPokemonMoveMethod: Object {
    @Persisted var versionGroup: VersionGroup?
    @Persisted var pokemonMoveMethod: PokemonMoveMethod?
}

class VersionGroupRegion: Object {
    @Persisted var versionGroup: VersionGroup?
    @Persisted var region: Region?
}

class VersionGroup: Object {
    @Persisted(primaryKey: true) var id = 0
    @Persisted var identifier = ""
    @Persisted var generation: Generation?
    @Persisted var order = 0

    let versionGroupRegions = LinkingObjects(fromType: VersionGroupRegion.self, property: "versionGroup")
    let pokemonMoveMethods = LinkingObjects(fromType: VersionGroupPokemonMoveMethod.self, property: "versionGroup")
    let versions = LinkingObjects(fromType: Version.self, property: "versionGroup")
    let pokedexes = LinkingObjects(fromType: PokedexVersionGroup.self, property: "versionGroup")
    let machines = LinkingObjects(fromType: Machine.self, property: "versionGroup")
    let encounterSlots = LinkingObjects(fromType: EncounterSlot.self, property: "versionGroup")
}

class VersionName: Object {
    @Persisted var version: Version?
    @Persisted var localLanguageId: Int = 0
    @Persisted var name: String = ""
}

class Version: Object, Identifiable {
    @Persisted(primaryKey: true) var id = 0
    @Persisted var identifier: String = ""
    @Persisted var versionGroup: VersionGroup?

    let names = LinkingObjects(fromType: VersionName.self, property: "version")
    let pokemonGameIndices = LinkingObjects(fromType: PokemonGameIndex.self, property: "version")
    let encounters = LinkingObjects(fromType: Encounter.self, property: "version")
}
