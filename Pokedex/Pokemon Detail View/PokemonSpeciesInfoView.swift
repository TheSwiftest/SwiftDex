//
//  PokemonSpeciesInfoView.swift
//  Pokedex
//
//  Created by TempUser on 1/25/21.
//

import SwiftUI

struct PokemonBasicInfoView: View {
    
    let species: PokemonSpecies
    @Binding var pokemon: Pokemon
    @Binding var pokemonForm: PokemonForm
    @Binding var selectedVersionGroup: VersionGroup
    
    var body: some View {
        ScrollView {
            VStack {
                Group {
                    SpeciesBasicInfoView(id: pokemon.id, height: pokemon.height, weight: pokemon.weight, bodyShape: species.shape!.id, genus: species.names.first(where: {$0.localLanguageId == 9})!.genus, color: pokemon.types.first(where: {$0.slot == 1})!.type!.color)
                    PokemonAbilitiesView(pokemon: $pokemon)
                    PokemonStatsView(pokemon: $pokemon)
                    PokemonEvolutionChainView(species: species)
                    PokemonAlternateFormsView(species: species, selectedPokemon: $pokemon, selectedForm: $pokemonForm, selectedVersionGroup: $selectedVersionGroup)
                }
                .padding()
            }
        }
    }
}

struct SpeciesBasicInfoView: View {
    
    let id: Int
    let height: Int
    let weight: Int
    let bodyShape: Int
    let genus: String
    let color: Color
    
    private var heightInMetersText: String {
        return String(format: "%.1f", CGFloat(height) / 10)
    }
    
    private var weightInKGText: String {
        return String(format: "%.1f", CGFloat(weight) / 10)
    }
    
    var body: some View {
        VStack {
            PokemonDetailSectionHeader(text: "Species Info")
            HStack(alignment: .lastTextBaseline) {
                Group {
                    SpeciesInfoTextView(title: "\(heightInMetersText)m", subtitle: "Height")
                    SpeciesInfoTextView(title: "\(weightInKGText)kg", subtitle: "Weight")
                    SpeciesInfoImageView(image: Image("cry"), imageSize: 18, subtitle: "Cry", color: color)
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            }
            HStack(alignment: .lastTextBaseline) {
                Group {
                    SpeciesInfoImageView(image: Image("Body\(bodyShape)"), imageSize: 30, subtitle: "Shape", color: nil)
                    SpeciesInfoImageView(image: Image("F\(id)"), imageSize: 30, subtitle: "Footprint", color: color)
                    SpeciesInfoTextView(title: genus.replacingOccurrences(of: " Pokémon", with: "").capitalized, subtitle: "Genus")
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            }
        }
    }
}

struct SpeciesInfoTextView: View {
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(spacing: 0) {
            Text(title)
                .font(.headline)
            Text(subtitle)
                .font(.caption)
        }
    }
}

struct SpeciesInfoImageView: View {

    let image: Image
    let imageSize: CGFloat
    let subtitle: String
    let color: Color?
    
    var body: some View {
        VStack(spacing: 0) {
            image
                .resizable()
                .frame(width: imageSize, height: imageSize, alignment: .center)
                .foregroundColor(color)
            Text(subtitle)
                .font(.caption)
        }
    }
}