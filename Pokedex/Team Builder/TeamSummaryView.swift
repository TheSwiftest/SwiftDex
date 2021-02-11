//
//  TeamSummaryView.swift
//  Pokedex
//
//  Created by TempUser on 2/6/21.
//

import SwiftUI
import Kingfisher

struct TeamSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        TeamSummaryView(team: testTeams[0]).environmentObject(PokemonShowdownService())
    }
}

struct TeamSummaryView: View {
    @EnvironmentObject var pokemonShowdownService: PokemonShowdownService
    let team: Team
    
    var body: some View {
        VStack {
            HStack {
                Text(team.name)
                    .font(.title)
                    .bold()
                Spacer()
                Button(action: {
                    pokemonShowdownService.exportToClipboard(team)
                }, label: {
                    Image(systemName: "doc.on.doc")
                        .font(.title2)
                        .foregroundColor(Color(.secondaryLabel))
                })
            }
            
            HStack {
                Text(team.format.identifier)
                    .font(.caption)
                
                Spacer()
            }
            
            LazyVGrid(columns: [GridItem(.flexible(), spacing: 15), GridItem(.flexible(), spacing: 15), GridItem(.flexible(), spacing: 15)], spacing: 15) {
                ForEach(0...5, id: \.self) { index in
                    let pokemon: TeamPokemon? = team.pokemon.count > index ? team.pokemon[index] : nil
                    TeamMemberSummaryView(pokemon: pokemon)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
    }
}

struct TeamMemberSummaryView: View {
    let pokemon: TeamPokemon?
    
    private var backgroundColor: Color {
        if let pokemon = pokemon {
            return pokemon.pokemon.color.opacity(0.25)
        }
        
        return Color(.secondarySystemBackground)
    }
    
    var body: some View {
        ZStack {
            pokemon?.sprite
                .resizable()
                .scaledToFit()
                .padding()
                .background(backgroundColor)
                .cornerRadius(10)
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    pokemon?.item?.image
                        .resizable()
                        .frame(width: 35, height: 35)
                        .padding(.bottom, 2)
                        .padding(.trailing, 2)
                }
            }
        }
        
    }
}
