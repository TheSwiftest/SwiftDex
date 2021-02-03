//
//  PokemonMovesView.swift
//  Pokedex
//
//  Created by TempUser on 1/26/21.
//

import SwiftUI

struct PokemonMovesView: View {
    
    @Binding var selectedPokemon: Pokemon
    
    @State var selectedLearnMethod: PokemonMoveMethod
    @Binding var selectedVersion: Version
    
    @Binding var selectedMove: Move?
    @Binding var showMoveDetailView: Bool
    
    private var moveLearnMethodsForSelectedVersion: [PokemonMoveMethod] {
        return selectedVersion.versionGroup!.pokemonMoveMethods.filter("pokemonMoveMethod.id <= 4").compactMap({$0.pokemonMoveMethod})
    }
    
    private var versionColor: Color {
        return selectedVersion.color
    }
    
    private var versionName: String {
        return selectedVersion.names.first(where: {$0.localLanguageId == 9})?.name ?? "All Versions"
    }
    
    private var movesToDisplay: [PokemonMove] {
        var movesToDisplay = selectedPokemon.moves.filter("pokemonMoveMethod.id == \(selectedLearnMethod.id)")
        movesToDisplay = movesToDisplay.filter("versionGroup.id == \(selectedVersion.versionGroup!.id)")
        
        if selectedLearnMethod.id == 1 {
            movesToDisplay = movesToDisplay.sorted(byKeyPath: "level", ascending: true)
        }
        
        if selectedLearnMethod.id == 4 {
            return movesToDisplay.compactMap({$0}).sorted { (moveA, moveB) -> Bool in
                let machineNameA = moveA.machineName(for: selectedVersion.versionGroup!)!
                let machineNameB = moveB.machineName(for: selectedVersion.versionGroup!)!
                
                if machineNameA.count == machineNameB.count {
                    return machineNameA < machineNameB
                }
                
                return machineNameA.count < machineNameB.count
            }
        }
        
        return movesToDisplay.compactMap({$0})
    }
    
    var body: some View {
        VStack(spacing: 5) {
            VStack {
                Picker("Learn Methods", selection: $selectedLearnMethod) {
                    ForEach(moveLearnMethodsForSelectedVersion) { method in
                        Text(method.prose.first(where: {$0.localLanguageId == 9})!.name).tag(method)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                Text(selectedLearnMethod.prose.first(where: {$0.localLanguageId == 9})!.pokemonMoveMethodProseDescription)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
            }
            .padding(.horizontal)
            
            ZStack {
                GeometryReader { geo in
                    Rectangle()
                        .foregroundColor(Color(.secondarySystemBackground))
                    ScrollView {
                        LazyVStack(spacing: 2) {
                            ForEach(movesToDisplay, id:\.self) { pokemonMove in
                                MoveView(move: pokemonMove.move!, pokemonMove: pokemonMove, versionGroup: selectedVersion.versionGroup!)
                                    .onTapGesture {
                                        selectedMove = pokemonMove.move!
                                        showMoveDetailView = true
                                    }
                            }
                        }
                    }
                }
            }
        }
        .padding(.top)
    }
}

struct MoveView: View {
    
    let move: Move
    let pokemonMove: PokemonMove?
    let versionGroup: VersionGroup
    
    private var subtitle: String? {
        guard let pokemonMove = pokemonMove, let moveMethod = pokemonMove.pokemonMoveMethod else {
            return nil
        }
        
        if moveMethod.id == 1 {
            return "Level \(pokemonMove.level)"
        }
        
        if moveMethod.id == 4 {
            guard let moveVersionGroup = pokemonMove.versionGroup, let machine = move.machines.first(where: {$0.versionGroup!.id == moveVersionGroup.id}), let machineItem = machine.item else {
                return nil
            }
            
            return machineItem.names.first(where: {$0.localLanguageId == 9})!.name
        }
    
        
        return nil
    }
    
    private var powerText: String {
        guard let power = move.power.value else {
            return "-"
        }
        
        return "\(power)"
    }
    
    private var accuracyText: String {
        guard let accuracy = move.accuracy.value else {
            return "-"
        }
        
        return "\(accuracy)"
    }
    
    private var ppText: String {
        guard let pp = move.pp.value else {
            return "-"
        }
        
        return "\(pp)"
    }
        
    var body: some View {
        HStack {
            Circle()
                .frame(width: 30, height: 30)
                .foregroundColor(move.type!.color)
                .overlay(
                    move.type!.icon
                        .frame(width: 24, height: 24)
                        .foregroundColor(Color(.white))
                )
            
            VStack(alignment: .leading) {
                Text(move.name)
                    .font(.title2)
                    .fontWeight(.semibold)
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.subheadline)
                }
            }
            .padding(.vertical, 10)
            
            Spacer()
            
            HStack(spacing: 0) {
                Text(powerText)
                    .frame(width: 45)
                Rectangle()
                    .frame(width: 1)
                    .foregroundColor(Color(.systemBackground))
                Text(accuracyText)
                    .frame(width: 45)
                Rectangle()
                    .frame(width: 1)
                    .foregroundColor(Color(.systemBackground))
                Text(ppText)
                    .frame(width: 45)
            }
            .background(Color(.systemFill))
            .frame(height: 35)
            .cornerRadius(20)
            
            if let damageClass = move.damageClass {
                Circle()
                    .frame(width: 30, height: 30)
                    .foregroundColor(damageClass.backgroundColor)
                    .overlay(
                        damageClass.icon
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(damageClass.color)
                    )
            }
        }
        .padding(.horizontal)
        .background(Color(.systemBackground))
    }
}
