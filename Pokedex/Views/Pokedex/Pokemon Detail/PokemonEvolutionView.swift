//
//  PokemonEvolutionView.swift
//  Pokedex
//
//  Created by TempUser on 1/25/21.
//

import SwiftUI
import Kingfisher

struct PokemonEvolutionChainView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonEvolutionChainView(pokemon: SwiftDexService().pokemon(withId: 2)!)
    }
}

struct PokemonEvolutionChainView: View {

    let pokemon: Pokemon

    var body: some View {
        VStack {
            if pokemon.evolvesFrom != nil || pokemon.evolvesTo.count > 0 {
                PokemonDetailSectionHeader(text: "Evolutions")
            }

            if let evolvesFromPokemon = pokemon.evolvesFrom {
                PokemonEvolutionStepView(fromPokemon: evolvesFromPokemon, toPokemon: pokemon)
            }

            ForEach(pokemon.evolvesTo) { evolvesToPokemon in
                PokemonEvolutionStepView(fromPokemon: pokemon, toPokemon: evolvesToPokemon)
            }
        }
    }
}

struct PokemonEvolutionStepView: View {
    let fromPokemon: Pokemon
    let toPokemon: Pokemon

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(Color(.secondarySystemBackground))
            HStack {
                fromPokemon.sprite
                    .resizable()
                    .frame(width: 125, height: 125)

                if let evolution = toPokemon.pokemonEvolution.first {
                    PokemonEvolutionStepTriggerView(evolution: evolution)
                }

                toPokemon.sprite
                    .resizable()
                    .frame(width: 125, height: 125)
            }
        }
    }
}

struct PokemonEvolutionStepTriggerView: View {
    let evolution: PokemonEvolution

    var body: some View {
        VStack {
            Text(evolution.evolutionTrigger!.name)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            EvolutionStepTriggerSectionOne(evolution: evolution)
            EvolutionStepTriggerSectionTwo(evolution: evolution)
        }
    }
}

struct EvolutionStepTriggerSectionTwo: View {
    let evolution: PokemonEvolution

    var body: some View {
        if let knownMove = evolution.knownMove {
            Text(knownMove.name)
        }

        if let knownMoveType = evolution.knownMoveType {
            Text(knownMoveType.name)
        }

        if let relativePhysicalStats = evolution.relativePhysicalStats.value {
            Text("Phy Stats. \(relativePhysicalStats)")
        }

        if let partySpecies = evolution.partySpecies {
            partySpecies.defaultForm.sprite
                .resizable()
                .frame(width: 50, height: 50)
        }

        if let tradeSpecies = evolution.tradeSpecies {
            tradeSpecies.defaultForm.sprite
                .resizable()
                .frame(width: 50, height: 50)
        }

        if let partyType = evolution.partyType {
            Text(partyType.name)
        }

        if evolution.needsOverworldRain {
            Text("Raining")
        }

        if evolution.turnUpsideDown {
            Text("Turn Upside Down")
        }
    }
}

struct EvolutionStepTriggerSectionOne: View {

    let evolution: PokemonEvolution

    var body: some View {
        if let minimumLevel = evolution.minimumLevel.value {
            Text("Min Lvl. \(minimumLevel)")
        }

        if let triggerItem = evolution.triggerItem {
            triggerItem.sprite
                .resizable()
                .frame(width: 25, height: 25)
        }

        if let heldItem = evolution.heldItem {
            heldItem.sprite
                .resizable()
                .frame(width: 25, height: 25)
        }

        if let minimumHappiness = evolution.minimumHappiness.value {
            Text("Min Hap. \(minimumHappiness)")
        }

        if let minimumBeauty = evolution.minimumBeauty.value {
            Text("Min Bea. \(minimumBeauty)")
        }

        if !evolution.timeOfDay.isEmpty {
            Text("\(evolution.timeOfDay.capitalized)time")
        }

        if let gender = evolution.gender {
            Text(gender.name)
        }

        if let location = evolution.location {
            Text(location.name)
        }

        if let minimumAffection = evolution.minimumAffection.value {
            Text("Min Aff. \(minimumAffection)")
        }
    }
}

// struct PokemonEvolutionChainView: View {
//    
//    let evolutionChain: EvolutionChain
//    
//    private func calculateXOffset(forIndex index: Int, outOfTotal total: Int, aroundCircleWithRadius radius: CGFloat) -> CGFloat {
//        return radius * cos(2 * CGFloat(Double.pi) * CGFloat(index + 1) / CGFloat(total))
//    }
//    
//    private func calculateYOffset(forIndex index: Int, outOfTotal total: Int, aroundCircleWithRadius radius: CGFloat) -> CGFloat {
//        return radius * sin(2 * CGFloat(Double.pi) * CGFloat(index + 1) / CGFloat(total))
//    }
//    
//    var body: some View {
//        VStack {
//            PokemonDetailSectionHeader(text: "Evolution Chain")
//            if evolutionChain.style == .circular {
//                GeometryReader { geo in
//                    ZStack {
//                        Circle()
//                            .stroke()
//                            .foregroundColor(.clear)
//                        EvolutionStepView(pokemonId: evolutionChain.chain.species.id)
//                            .frame(height: 80)
//                        ForEach(evolutionChain.chain.evolvesTo.indices) { index in
//                            Image("\(evolutionChain.chain.evolvesTo[index].triggerInfo!.item!.id)_item_icon")
//                                .offset(x: calculateXOffset(forIndex: index, outOfTotal: evolutionChain.chain.evolvesTo.count, aroundCircleWithRadius: (geo.size.width / 4) - 20),
//                                        y: calculateYOffset(forIndex: index, outOfTotal: evolutionChain.chain.evolvesTo.count, aroundCircleWithRadius: (geo.size.width / 4) - 20))
//                            EvolutionStepView(pokemonId: evolutionChain.chain.evolvesTo[index].species.id)
//                                .frame(height: 80)
//                                .offset(x: calculateXOffset(forIndex: index, outOfTotal: evolutionChain.chain.evolvesTo.count, aroundCircleWithRadius: (geo.size.width / 2) - 40),
//                                        y: calculateYOffset(forIndex: index, outOfTotal: evolutionChain.chain.evolvesTo.count, aroundCircleWithRadius: (geo.size.width / 2) - 40))
//                        }
//                    }
//                }
//                .frame(height: UIScreen.main.bounds.size.width)
//            }
//            
//            if evolutionChain.style == .linear {
//                ScrollView(.horizontal) {
//                    HStack {
//                        ForEach(evolutionChain.steps().indices) { index in
//                            VStack {
//                                ForEach(evolutionChain.steps()[index].indices) { indexB in
//                                    HStack {
//                                        if let triggerInfo = evolutionChain.steps()[index][indexB].triggerInfo {
//                                            if triggerInfo.type == .levelUp {
//                                                EvolutionTriggerView(imageName: "arrow.right", text: "Level \(triggerInfo.minimumLevel!)")
//                                            }
//
//                                            if triggerInfo.type == .useItem {
//                                                EvolutionTriggerView(imageName: "\(triggerInfo.item!.id)_item_icon", text: "Use")
//                                            }
//                                        }
//                                        EvolutionStepView(pokemonId: evolutionChain.steps()[index][indexB].species.id)
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
// }
//
// struct EvolutionTriggerView: View {
//    let imageName: String
//    let text: String
//    
//    var body: some View {
//        VStack {
//            Image(systemName: "arrow.right")
//                .foregroundColor(.secondary)
//            Text(text)
//                .font(.caption)
//                .lineLimit(1)
//        }
//    }
// }
//
// struct EvolutionStepView: View {
//    
//    let pokemonId: Int
//
//    var body: some View {
//        ZStack {
//            Rectangle()
//                .cornerRadius(23)
//                .foregroundColor(Color(.secondarySystemBackground))
//                .frame(width: 80)
//            Image("\(pokemonId)_sprite")
//                .resizable()
//                .frame(width: 70, height: 70)
//        }
//    }
// }
