//
//  TestData.swift
//  SwiftDex
//
//  Created by Brian Corbin on 4/3/22.
//

import Foundation

let nationalDex = PokedexInfo(id: 1, identifier: "national", name: "National")
let kantoDex = PokedexInfo(id: 2, identifier: "kanto", name: "Kanto")
let originalJohtoDex = PokedexInfo(id: 3, identifier: "original-johto", name: "Johto")
let updatedAlolaDex = PokedexInfo(id: 21, identifier: "updated-alola", name: "Alola")
let updatedMelemele = PokedexInfo(id: 22, identifier: "updated-melemele", name: "Melemele")
let updatedAkala = PokedexInfo(id: 23, identifier: "updated-akala", name: "Akala")
let updatedUlaula = PokedexInfo(id: 24, identifier: "updated-ulaula", name: "Ulaula")
let updatedPoni = PokedexInfo(id: 25, identifier: "updated-poni", name: "Poni")
let galar = PokedexInfo(id: 27, identifier: "galar", name: "Galar")
let isleOfArmorDex = PokedexInfo(id: 28, identifier: "isle-of-armor", name: "Isle of Armor")
let crownTundraDex = PokedexInfo(id: 29, identifier: "crown-tundra", name: "Crown Tundra")

let redVersion = VersionInfo(id: 1, name: "Red", identifier: "red")
let blueVersion = VersionInfo(id: 2, name: "Blue", identifier: "blue")
let yellowVersion = VersionInfo(id: 3, name: "Yellow", identifier: "yellow")
let goldVersion = VersionInfo(id: 4, name: "Gold", identifier: "gold")
let silverVersion = VersionInfo(id: 5, name: "Silver", identifier: "silver")
let crystalVersion = VersionInfo(id: 6, name: "Crystal", identifier: "crystal")
let ultraSunVersion = VersionInfo(id: 29, name: "Ultra Sun", identifier: "ultra-sun")
let ultraMoonVersion = VersionInfo(id: 30, name: "Ultra Moon", identifier: "ultra-moon")
let swordVersion = VersionInfo(id: 33, name: "Sword", identifier: "sword")
let shieldVersion = VersionInfo(id: 34, name: "Shield", identifier: "shield")

let redBlueVG = VersionGroupInfo(id: 1, identifier: "red-blue", order: 1, versions: [redVersion, blueVersion], pokedexes: [kantoDex, nationalDex])
let yellowVG = VersionGroupInfo(id: 2, identifier: "yellow", order: 2, versions: [yellowVersion], pokedexes: [kantoDex, nationalDex])
let goldSilverVG = VersionGroupInfo(id: 3, identifier: "gold-silver", order: 3, versions: [goldVersion, silverVersion], pokedexes: [originalJohtoDex, nationalDex])
let crystalVG = VersionGroupInfo(id: 4, identifier: "crystal", order: 4, versions: [crystalVersion], pokedexes: [originalJohtoDex, nationalDex])
let usumVG = VersionGroupInfo(id: 18, identifier: "ultra-sun-ultra-moon", order: 18, versions: [ultraSunVersion, ultraMoonVersion], pokedexes: [updatedAlolaDex, updatedMelemele, updatedAkala, updatedUlaula, updatedPoni, nationalDex])
let swordShieldVG = VersionGroupInfo(id: 20, identifier: "sword-shield", order: 20, versions: [swordVersion, shieldVersion], pokedexes: [galar, isleOfArmorDex, crownTundraDex, nationalDex])

let gen1 = GenerationInfo(id: 1, identifier: "generation-I", name: "Generation I", versionGroups: [redBlueVG, yellowVG])
let gen2 = GenerationInfo(id: 2, identifier: "generation-II", name: "Generation II", versionGroups: [goldSilverVG, crystalVG])
let gen7 = GenerationInfo(id: 7, identifier: "generation-VII", name: "Generation VII", versionGroups: [usumVG])
let gen8 = GenerationInfo(id: 8, identifier: "generation-VIII", name: "Generation VIII", versionGroups: [swordShieldVG])

let testGenerations = [gen1, gen2, gen7, gen8]

let testVersionGroups = [redBlueVG, yellowVG, goldSilverVG, crystalVG, usumVG, swordShieldVG]

let grass = PokemonSummary.PokemonType(typeData: .grass, name: "Grass")
let poison = PokemonSummary.PokemonType(typeData: .poison, name: "Poison")
let fire = PokemonSummary.PokemonType(typeData: .fire, name: "Fire")
let flying = PokemonSummary.PokemonType(typeData: .flying, name: "Flying")
let water = PokemonSummary.PokemonType(typeData: .water, name: "Water")

let testPokemonTypes: [TypeEffectiveness.TypeData] = [.grass, .poison]

let bulbasaurSpeciesInfo = SpeciesInfo(id: 1, height: 30, weight: 30, bodyShape: 1, genus: "Seed")
let ivysaurSpeciesInfo = SpeciesInfo(id: 2, height: 30, weight: 30, bodyShape: 1, genus: "Seed")
let venusaurSpeciesInfo = SpeciesInfo(id: 3, height: 30, weight: 30, bodyShape: 1, genus: "Seed")
let charmanderSpeciesInfo = SpeciesInfo(id: 4, height: 30, weight: 30, bodyShape: 1, genus: "Seed")
let charmeleonSpeciesInfo = SpeciesInfo(id: 5, height: 30, weight: 30, bodyShape: 1, genus: "Seed")
let charizardSpeciesInfo = SpeciesInfo(id: 6, height: 30, weight: 30, bodyShape: 1, genus: "Seed")
let squirtleSpeciesInfo = SpeciesInfo(id: 7, height: 30, weight: 30, bodyShape: 1, genus: "Seed")
let wartortleSpeciesInfo = SpeciesInfo(id: 8, height: 30, weight: 30, bodyShape: 1, genus: "Seed")
let blastoiseSpeciesInfo = SpeciesInfo(id: 9, height: 30, weight: 30, bodyShape: 1, genus: "Seed")

let overgrow = PokemonAbilityInfo(name: "Overgrow", isHidden: false)
let chlorophyll = PokemonAbilityInfo(name: "Chlorophyll", isHidden: true)

let bulbasaurStats = [
    PokemonStatInfo(identifier: "hp", name: "HP", value: 60, effortValue: 1),
    PokemonStatInfo(identifier: "atk", name: "ATK", value: 62, effortValue: 1),
    PokemonStatInfo(identifier: "def", name: "DEF", value: 63, effortValue: 1),
    PokemonStatInfo(identifier: "satk", name: "SATK", value: 80, effortValue: 1),
    PokemonStatInfo(identifier: "sdef", name: "SDEF", value: 80, effortValue: 1),
    PokemonStatInfo(identifier: "spe", name: "SPE", value: 60, effortValue: 1)]
let ivysaurStats = [
    PokemonStatInfo(identifier: "hp", name: "HP", value: 60, effortValue: 1),
    PokemonStatInfo(identifier: "atk", name: "ATK", value: 62, effortValue: 1),
    PokemonStatInfo(identifier: "def", name: "DEF", value: 63, effortValue: 1),
    PokemonStatInfo(identifier: "satk", name: "SATK", value: 80, effortValue: 1),
    PokemonStatInfo(identifier: "sdef", name: "SDEF", value: 80, effortValue: 1),
    PokemonStatInfo(identifier: "spe", name: "SPE", value: 60, effortValue: 1)]
let venusaurStats = [
    PokemonStatInfo(identifier: "hp", name: "HP", value: 60, effortValue: 1),
    PokemonStatInfo(identifier: "atk", name: "ATK", value: 62, effortValue: 1),
    PokemonStatInfo(identifier: "def", name: "DEF", value: 63, effortValue: 1),
    PokemonStatInfo(identifier: "satk", name: "SATK", value: 80, effortValue: 1),
    PokemonStatInfo(identifier: "sdef", name: "SDEF", value: 80, effortValue: 1),
    PokemonStatInfo(identifier: "spe", name: "SPE", value: 60, effortValue: 1)]
let charmanderStats = [
    PokemonStatInfo(identifier: "hp", name: "HP", value: 60, effortValue: 1),
    PokemonStatInfo(identifier: "atk", name: "ATK", value: 62, effortValue: 1),
    PokemonStatInfo(identifier: "def", name: "DEF", value: 63, effortValue: 1),
    PokemonStatInfo(identifier: "satk", name: "SATK", value: 80, effortValue: 1),
    PokemonStatInfo(identifier: "sdef", name: "SDEF", value: 80, effortValue: 1),
    PokemonStatInfo(identifier: "spe", name: "SPE", value: 60, effortValue: 1)]
let charmeleonStats = [
    PokemonStatInfo(identifier: "hp", name: "HP", value: 60, effortValue: 1),
    PokemonStatInfo(identifier: "atk", name: "ATK", value: 62, effortValue: 1),
    PokemonStatInfo(identifier: "def", name: "DEF", value: 63, effortValue: 1),
    PokemonStatInfo(identifier: "satk", name: "SATK", value: 80, effortValue: 1),
    PokemonStatInfo(identifier: "sdef", name: "SDEF", value: 80, effortValue: 1),
    PokemonStatInfo(identifier: "spe", name: "SPE", value: 60, effortValue: 1)]
let charizardStats = [
    PokemonStatInfo(identifier: "hp", name: "HP", value: 60, effortValue: 1),
    PokemonStatInfo(identifier: "atk", name: "ATK", value: 62, effortValue: 1),
    PokemonStatInfo(identifier: "def", name: "DEF", value: 63, effortValue: 1),
    PokemonStatInfo(identifier: "satk", name: "SATK", value: 80, effortValue: 1),
    PokemonStatInfo(identifier: "sdef", name: "SDEF", value: 80, effortValue: 1),
    PokemonStatInfo(identifier: "spe", name: "SPE", value: 60, effortValue: 1)]
let squirtleStats = [
    PokemonStatInfo(identifier: "hp", name: "HP", value: 60, effortValue: 1),
    PokemonStatInfo(identifier: "atk", name: "ATK", value: 62, effortValue: 1),
    PokemonStatInfo(identifier: "def", name: "DEF", value: 63, effortValue: 1),
    PokemonStatInfo(identifier: "satk", name: "SATK", value: 80, effortValue: 1),
    PokemonStatInfo(identifier: "sdef", name: "SDEF", value: 80, effortValue: 1),
    PokemonStatInfo(identifier: "spe", name: "SPE", value: 60, effortValue: 1)]
let wartortleStats = [
    PokemonStatInfo(identifier: "hp", name: "HP", value: 60, effortValue: 1),
    PokemonStatInfo(identifier: "atk", name: "ATK", value: 62, effortValue: 1),
    PokemonStatInfo(identifier: "def", name: "DEF", value: 63, effortValue: 1),
    PokemonStatInfo(identifier: "satk", name: "SATK", value: 80, effortValue: 1),
    PokemonStatInfo(identifier: "sdef", name: "SDEF", value: 80, effortValue: 1),
    PokemonStatInfo(identifier: "spe", name: "SPE", value: 60, effortValue: 1)]
let blastoiseStats = [
    PokemonStatInfo(identifier: "hp", name: "HP", value: 60, effortValue: 1),
    PokemonStatInfo(identifier: "atk", name: "ATK", value: 62, effortValue: 1),
    PokemonStatInfo(identifier: "def", name: "DEF", value: 63, effortValue: 1),
    PokemonStatInfo(identifier: "satk", name: "SATK", value: 80, effortValue: 1),
    PokemonStatInfo(identifier: "sdef", name: "SDEF", value: 80, effortValue: 1),
    PokemonStatInfo(identifier: "spe", name: "SPE", value: 60, effortValue: 1)]

let testPokemonEvolutionFrom = PokemonEvolutionInfo(id: 1, name: "Bulbasaur")
let testPokemonEvolutionTo = PokemonEvolutionInfo(id: 2, name: "Venasaur")

let testSpeciesExtraInfo = SpeciesExtraInfo(catchRate: 10, baseHappiness: 10, baseExperience: 10, growthRate: "fast", eggCycles: 60, genderRate: 4)

let testEggGroups = [EggGroupInfo(id: 1, name: "monster"), EggGroupInfo(id: 2, name: "plant")]

let testBreedingInfo = PokemonBreedingInfo(extraInfo: testSpeciesExtraInfo, eggGroups: testEggGroups, stats: bulbasaurStats, types: testPokemonTypes)

let levelUpLearnMoveMethod = MoveLearnMethod(id: 1, name: "Level up", description: "Learned when a Pokemon reaches a certain level.")
let eggLearnMoveMethod = MoveLearnMethod(id: 2, name: "Egg", description: "Appears on a newly-hatched Pokemon, if the father had the same move.")
let tutorLearnMoveMethod = MoveLearnMethod(id: 3, name: "Tutor", description: "Can be taught at any time by an NPC.")
let machineLearnMoveMethod = MoveLearnMethod(id: 4, name: "Machine", description: "Can be taught at any time by using a TM or HM.")

let testMoveLearnMethods = [
    levelUpLearnMoveMethod,
    eggLearnMoveMethod,
    tutorLearnMoveMethod,
    machineLearnMoveMethod
]

let tackle = MoveInfo(id: 1, identifier: "tackle", name: "Tackle", type: .normal, damageClassIdentifier: "physical", damageClassName: "Physical", power: 40, accuracy: 100, pp: 35, priority: 1, effect: "Inflicts [regular damage]{mechanic:regular-damage}.", effectChance: 100, flavorText: "A physical attack in which the user charges and slams into the target with its whole body.", target: "One other Pokemon on the field, selected by the trainer.", machineName: nil)
let growl = MoveInfo(id: 2, identifier: "growl", name: "Growl", type: .normal, damageClassIdentifier: "status", damageClassName: "Status", power: nil, accuracy: 100, pp: 40, priority: 1, effect: "Inflicts [regular damage]{mechanic:regular-damage}.", effectChance: 100, flavorText: "A physical attack in which the user charges and slams into the target with its whole body.", target: "One other Pokemon on the field, selected by the trainer.", machineName: nil)
let leechSeed = MoveInfo(id: 3, identifier: "leech-seed", name: "Leech Seed", type: .grass, damageClassIdentifier: "status", damageClassName: "Status", power: nil, accuracy: 90, pp: 10, priority: 1, effect: "Inflicts [regular damage]{mechanic:regular-damage}.", effectChance: 100, flavorText: "A physical attack in which the user charges and slams into the target with its whole body.", target: "One other Pokemon on the field, selected by the trainer.", machineName: nil)
let vineWhip = MoveInfo(id: 4, identifier: "vine-whip", name: "Vine Whip", type: .grass, damageClassIdentifier: "special", damageClassName: "Special", power: 45, accuracy: 100, pp: 25, priority: 1, effect: "Inflicts [regular damage]{mechanic:regular-damage}.", effectChance: 100, flavorText: "A physical attack in which the user charges and slams into the target with its whole body.", target: "One other Pokemon on the field, selected by the trainer.", machineName: nil)
let poisonPowder = MoveInfo(id: 5, identifier: "poison-powder", name: "Poison Powder", type: .poison, damageClassIdentifier: "status", damageClassName: "Status", power: nil, accuracy: 75, pp: 35, priority: 1, effect: "Inflicts [regular damage]{mechanic:regular-damage}.", effectChance: 100, flavorText: "A physical attack in which the user charges and slams into the target with its whole body.", target: "One other Pokemon on the field, selected by the trainer.", machineName: nil)
let petalDance = MoveInfo(id: 6, identifier: "petal-dance", name: "Petal Dance", type: .grass, damageClassIdentifier: "special", damageClassName: "Special", power: 120, accuracy: 100, pp: 10, priority: 1, effect: "Inflicts [regular damage]{mechanic:regular-damage}.", effectChance: 100, flavorText: "A physical attack in which the user charges and slams into the target with its whole body.", target: "One other Pokemon on the field, selected by the trainer.", machineName: nil)
let sludge = MoveInfo(id: 7, identifier: "sludge", name: "Sludge", type: .poison, damageClassIdentifier: "special", damageClassName: "Special", power: 65, accuracy: 100, pp: 20, priority: 1, effect: "Inflicts [regular damage]{mechanic:regular-damage}.", effectChance: 100, flavorText: "A physical attack in which the user charges and slams into the target with its whole body.", target: "One other Pokemon on the field, selected by the trainer.", machineName: nil)
let grassPledge = MoveInfo(id: 8, identifier: "grass-pledge", name: "Grass Pledge", type: .grass, damageClassIdentifier: "special", damageClassName: "Special", power: 80, accuracy: 100, pp: 10, priority: 1, effect: "Inflicts [regular damage]{mechanic:regular-damage}.", effectChance: 100, flavorText: "A physical attack in which the user charges and slams into the target with its whole body.", target: "One other Pokemon on the field, selected by the trainer.", machineName: nil)
let workUp = MoveInfo(id: 9, identifier: "work-up", name: "Work Up", type: .normal, damageClassIdentifier: "status", damageClassName: "Status", power: nil, accuracy: nil, pp: 30, priority: 1, effect: "Inflicts [regular damage]{mechanic:regular-damage}.", effectChance: 100, flavorText: "A physical attack in which the user charges and slams into the target with its whole body.", target: "One other Pokemon on the field, selected by the trainer.", machineName: "TM01")

let testMoves = [tackle, growl, leechSeed, vineWhip, poisonPowder, petalDance, sludge, grassPledge, workUp]

let tackleLevelUp = PokemonMoveInfo(moveLearnInfo: PokemonMoveLearnInfo(moveLearnMethod: testMoveLearnMethods[0], level: 1, order: nil), moveInfo: tackle)
let growlLevelUp = PokemonMoveInfo(moveLearnInfo: PokemonMoveLearnInfo(moveLearnMethod: testMoveLearnMethods[0], level: 3, order: nil), moveInfo: growl)
let leechSeedLevelUp = PokemonMoveInfo(moveLearnInfo: PokemonMoveLearnInfo(moveLearnMethod: testMoveLearnMethods[0], level: 7, order: nil), moveInfo: leechSeed)
let vineWhipLevelUp = PokemonMoveInfo(moveLearnInfo: PokemonMoveLearnInfo(moveLearnMethod: testMoveLearnMethods[0], level: 9, order: nil), moveInfo: vineWhip)
let poisonPowderLevelUp = PokemonMoveInfo(moveLearnInfo: PokemonMoveLearnInfo(moveLearnMethod: testMoveLearnMethods[0], level: 13, order: nil), moveInfo: poisonPowder)

let petalDanceEgg = PokemonMoveInfo(moveLearnInfo: PokemonMoveLearnInfo(moveLearnMethod: testMoveLearnMethods[1], level: 0, order: nil), moveInfo: grassPledge)
let sludgeEgg = PokemonMoveInfo(moveLearnInfo: PokemonMoveLearnInfo(moveLearnMethod: testMoveLearnMethods[1], level: 0, order: nil), moveInfo: sludge)

let grassPledgeTutor = PokemonMoveInfo(moveLearnInfo: PokemonMoveLearnInfo(moveLearnMethod: testMoveLearnMethods[2], level: 0, order: nil), moveInfo: grassPledge)

let workUpMachine = PokemonMoveInfo(moveLearnInfo: PokemonMoveLearnInfo(moveLearnMethod: testMoveLearnMethods[3], level: 0, order: nil), moveInfo: workUp)

let testPokemonMoves = [tackleLevelUp, growlLevelUp, leechSeedLevelUp, vineWhipLevelUp, poisonPowderLevelUp, petalDanceEgg, sludgeEgg, grassPledgeTutor, workUpMachine]

let testPokemonMovesInfo = PokemonMovesInfo(moveLearnMethods: testMoveLearnMethods, pokemonMoves: testPokemonMoves)

let bulbasaurSummary = PokemonSummary(id: 1, speciesId: 1, pokedexNumber: 1, name: "Bulbasaur", types: [grass, poison], versionName: "Sword", formIdentifier: nil)
let ivysaurSummary = PokemonSummary(id: 2, speciesId: 2, pokedexNumber: 2, name: "Ivysaur", types: [grass, poison], versionName: "Sword", formIdentifier: nil)
let venusaurSummary = PokemonSummary(id: 3, speciesId: 3, pokedexNumber: 3, name: "Venusaur", types: [grass, poison], versionName: "Sword", formIdentifier: nil)
let charmanderSummary = PokemonSummary(id: 4, speciesId: 4, pokedexNumber: 4, name: "Charmander", types: [fire], versionName: "Sword", formIdentifier: nil)
let charmeleonSummary = PokemonSummary(id: 5, speciesId: 5, pokedexNumber: 5, name: "Charmeleon", types: [fire], versionName: "Sword", formIdentifier: nil)
let charizardSummary = PokemonSummary(id: 6, speciesId: 6, pokedexNumber: 6, name: "Charizard", types: [fire, flying], versionName: "Sword", formIdentifier: nil)
let squirtleSummary = PokemonSummary(id: 7, speciesId: 7, pokedexNumber: 7, name: "Squirtle", types: [water], versionName: "Sword", formIdentifier: nil)
let wartortleSummary = PokemonSummary(id: 8, speciesId: 8, pokedexNumber: 8, name: "Wartortle", types: [water], versionName: "Sword", formIdentifier: nil)
let blastoiseSummary = PokemonSummary(id: 9, speciesId: 9, pokedexNumber: 9, name: "Blastoise", types: [water], versionName: "Sword", formIdentifier: nil)
let venusaurGMaxSummary = PokemonSummary(id: 10364, speciesId: 3, pokedexNumber: 9, name: "Gigantamax Venusaur", types: [grass, poison], versionName: "Sword", formIdentifier: "gmax")
let venusaurMegaSummary = PokemonSummary(id: 10133, speciesId: 3, pokedexNumber: 9, name: "Mega Venusaur", types: [grass, poison], versionName: "Sword", formIdentifier: "mega")

let bulbasaurBasicInfo = PokemonBasicInfo(speciesInfo: bulbasaurSpeciesInfo, abilitySlot1: overgrow, abilitySlot2: nil, abilitySlot3: chlorophyll, stats: bulbasaurStats, speciesVariations: [bulbasaurSummary], forms: [])
let ivysaurBasicInfo = PokemonBasicInfo(speciesInfo: ivysaurSpeciesInfo, abilitySlot1: overgrow, abilitySlot2: nil, abilitySlot3: chlorophyll, stats: ivysaurStats, speciesVariations: [ivysaurSummary], forms: [])
let venusaurBasicInfo = PokemonBasicInfo(speciesInfo: venusaurSpeciesInfo, abilitySlot1: overgrow, abilitySlot2: nil, abilitySlot3: chlorophyll, stats: venusaurStats, speciesVariations: [venusaurSummary, venusaurMegaSummary, venusaurGMaxSummary], forms: [])
let charmanderBasicInfo = PokemonBasicInfo(speciesInfo: charmanderSpeciesInfo, abilitySlot1: overgrow, abilitySlot2: nil, abilitySlot3: chlorophyll, stats: charmanderStats, speciesVariations: [charmanderSummary], forms: [])
let charmeleonBasicInfo = PokemonBasicInfo(speciesInfo: charmeleonSpeciesInfo, abilitySlot1: overgrow, abilitySlot2: nil, abilitySlot3: chlorophyll, stats: charmeleonStats, speciesVariations: [charmeleonSummary], forms: [])
let charizardBasicInfo = PokemonBasicInfo(speciesInfo: charizardSpeciesInfo, abilitySlot1: overgrow, abilitySlot2: nil, abilitySlot3: chlorophyll, stats: charizardStats, speciesVariations: [charizardSummary], forms: [])
let squirtleBasicInfo = PokemonBasicInfo(speciesInfo: squirtleSpeciesInfo, abilitySlot1: overgrow, abilitySlot2: nil, abilitySlot3: chlorophyll, stats: squirtleStats, speciesVariations: [squirtleSummary], forms: [])
let wartortleBasicInfo = PokemonBasicInfo(speciesInfo: wartortleSpeciesInfo, abilitySlot1: overgrow, abilitySlot2: nil, abilitySlot3: chlorophyll, stats: wartortleStats, speciesVariations: [wartortleSummary], forms: [])
let blastoiseBasicInfo = PokemonBasicInfo(speciesInfo: blastoiseSpeciesInfo, abilitySlot1: overgrow, abilitySlot2: nil, abilitySlot3: chlorophyll, stats: blastoiseStats, speciesVariations: [blastoiseSummary], forms: [])

let bulbasaurPokemonInfo = PokemonInfo(summary: bulbasaurSummary, basicInfo: bulbasaurBasicInfo, breedingInfo: testBreedingInfo, moveInfo: testPokemonMovesInfo)
let ivysaurPokemonInfo = PokemonInfo(summary: ivysaurSummary, basicInfo: ivysaurBasicInfo, breedingInfo: testBreedingInfo, moveInfo: testPokemonMovesInfo)
let venusaurPokemonInfo = PokemonInfo(summary: venusaurSummary, basicInfo: venusaurBasicInfo, breedingInfo: testBreedingInfo, moveInfo: testPokemonMovesInfo)
let venusaurMegaPokemonInfo = PokemonInfo(summary: venusaurMegaSummary, basicInfo: venusaurBasicInfo, breedingInfo: testBreedingInfo, moveInfo: testPokemonMovesInfo)
let venusaurGmaxPokemonInfo = PokemonInfo(summary: venusaurGMaxSummary, basicInfo: venusaurBasicInfo, breedingInfo: testBreedingInfo, moveInfo: testPokemonMovesInfo)
let charmanderPokemonInfo = PokemonInfo(summary: charmanderSummary, basicInfo: charmanderBasicInfo, breedingInfo: testBreedingInfo, moveInfo: testPokemonMovesInfo)
let charmeleonPokemonInfo = PokemonInfo(summary: charmeleonSummary, basicInfo: charmeleonBasicInfo, breedingInfo: testBreedingInfo, moveInfo: testPokemonMovesInfo)
let charizardPokemonInfo = PokemonInfo(summary: charizardSummary, basicInfo: charizardBasicInfo, breedingInfo: testBreedingInfo, moveInfo: testPokemonMovesInfo)
let squirtlePokemonInfo = PokemonInfo(summary: squirtleSummary, basicInfo: squirtleBasicInfo, breedingInfo: testBreedingInfo, moveInfo: testPokemonMovesInfo)
let wartortlePokemonInfo = PokemonInfo(summary: wartortleSummary, basicInfo: wartortleBasicInfo, breedingInfo: testBreedingInfo, moveInfo: testPokemonMovesInfo)
let blastoisePokemonInfo = PokemonInfo(summary: blastoiseSummary, basicInfo: blastoiseBasicInfo, breedingInfo: testBreedingInfo, moveInfo: testPokemonMovesInfo)

let testPokemonInfos = [bulbasaurPokemonInfo, ivysaurPokemonInfo, venusaurPokemonInfo, venusaurMegaPokemonInfo, venusaurGmaxPokemonInfo, charmanderPokemonInfo, charmeleonPokemonInfo, charizardPokemonInfo, squirtlePokemonInfo, wartortlePokemonInfo, blastoisePokemonInfo]

let testPokemonSummaries = [bulbasaurSummary, ivysaurSummary, venusaurSummary, charmanderSummary, charmeleonSummary, charizardSummary, squirtleSummary, wartortleSummary, blastoiseSummary]

let physicalDC = MoveDamageClassInfo(id: 1, identifier: "physical", name: "Physical")
let specialDC = MoveDamageClassInfo(id: 2, identifier: "special", name: "Special")
let statusDC = MoveDamageClassInfo(id: 3, identifier: "status", name: "Status")

let testMDCs = [physicalDC, specialDC, statusDC]

func testGetPokemonInfo(forId pokemonId: Int) -> PokemonInfo {
    return testPokemonInfos.first(where: {$0.id == pokemonId})!
}
