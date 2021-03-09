//
//  PokemonShowdownServiceTests.swift
//  SwiftDexTests
//
//  Created by Brian Corbin on 3/8/21.
//

import XCTest
@testable import Pokedex

class PokemonShowdownServiceTests: XCTestCase {
    
    var pokemonShowdownService: PokemonShowdownService!

    override func setUpWithError() throws {
        try super.setUpWithError()
        pokemonShowdownService = PokemonShowdownService()
    }

    override func tearDownWithError() throws {
        pokemonShowdownService = nil
        try super.tearDownWithError()
    }
    
    func testLoadPokemon() throws {
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
        
        XCTAssert(glaceon.evs == [0,50,0,0,0,0], "EV's should be [50]; is \(glaceon.evs)")
        XCTAssert(glaceon.ivs == [31,26,31,31,31,31], "IV's should be [31,26,31,31,31,31]; is \(glaceon.ivs)")
        
        XCTAssert(glaceon.totAtk == 123, "Total attack should be 123; is \(glaceon.totAtk)")
        XCTAssert(garchomp.totDef == 163, "Total defense should be 163; is \(garchomp.totDef)")
    }

}
