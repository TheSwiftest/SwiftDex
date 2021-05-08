//
//  BattleSimulatorTests.swift
//  SwiftDexTests
//
//  Created by Brian Corbin on 3/8/21.
//

import XCTest
@testable import Pokedex

class BattleSimulatorTests: XCTestCase {
    
    var battleSimulatorViewModel: BattleSimulatorViewModel!
    let pokemonShowdownService = PokemonShowdownService()
    let swiftDexService = SwiftDexService()
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        battleSimulatorViewModel = BattleSimulatorViewModel()
    }

    override func tearDownWithError() throws {
        battleSimulatorViewModel = nil
        try super.tearDownWithError()
    }

    func testDamageValues() throws {
        let glaceon = pokemonShowdownService.loadPokemon(from:
                """
                (Glaceon)
                Happiness: 255
                Level: 75
                Shiny: No
                EVs: 0 HP / 50 Atk / 0 Def / 0 SpA / 0 SpD / 0 Spe
                IVs: 31 HP / 26 Atk / 31 Def / 31 SpA / 31 SpD / 31 Spe
                """)!
        
        let garchomp = pokemonShowdownService.loadPokemon(from:
            """
            (Garchomp)
            Happiness: 255
            Level: 70
            Shiny: No
            EVs: 0 HP / 0 Atk / 20 Def / 0 SpA / 0 SpD / 0 Spe
            IVs: 31 HP / 31 Atk / 31 Def / 31 SpA / 31 SpD / 31 Spe
            """)!
        
        let iceFang = swiftDexService.move(with: "Ice Fang")
        
        battleSimulatorViewModel.attackingPokemon = glaceon
        battleSimulatorViewModel.defendingPokemon = garchomp
        battleSimulatorViewModel.selectedMove = iceFang
        
        let maxDamage = battleSimulatorViewModel.maxDamage
        let minDamage = battleSimulatorViewModel.minDamage
        
        XCTAssert(maxDamage == 198, "Max damage should be exactly 198; is \(maxDamage)")
        XCTAssert(minDamage == 168, "Min damage should be exactly 168; is \(minDamage)")
    }

}
