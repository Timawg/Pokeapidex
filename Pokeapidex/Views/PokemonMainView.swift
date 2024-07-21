//
//  PokemonMainView.swift
//  Pokeapidex
//
//  Created by Tim Gunnarsson on 2024-07-21.
//

import SwiftUI

struct PokemonMainView: View {
    
    @Environment(PokemonMainViewModel.self) var viewModel: PokemonMainViewModel
    
    @State var segmentState: SegmentState = .pokedex
    
    var body: some View {
        VStack(spacing: 8) {
            List {
                pokemonTopSection
                segmentedControl
                switch segmentState {
                case .pokedex:
                    pokemonList
                case .saved:
                    savedPokemonList
                }
            }
            .scrollContentBackground(.hidden)
        }
        .task {
            do {
                try await viewModel.getPokemon()
            } catch {
                
            }
        }
    }
    
    @ViewBuilder
    var pokemonTopSection: some View {
        Section {
            Image("pokemon-logo")
                .resizable()
                .frame(maxWidth: .infinity, maxHeight: 100)
        } footer: {
            if let randomPokemon = viewModel.randomPokemon {
                VStack {
                    PokemonTopView(name: randomPokemon.name, urlString: randomPokemon.artworkUrl, colors: randomPokemon.pokemonTypes.map { $0.color })
                        .padding()
                    
                    PokemonButtonStack(saved: viewModel.isSaved(pokemon: randomPokemon)) {
                        Task {
                            try await viewModel.randomizePokemon()
                        }
                    } onSave: {
                        viewModel.save(pokemon: randomPokemon)
                    }
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: 50)
                }
            }
        }
    }
    
    @ViewBuilder
    var segmentedControl: some View {
        Picker("Pokemon", selection: $segmentState, content: {
            Text("Pokedéx")
                .foregroundStyle(.white)
                .tag(SegmentState.pokedex)

            Text("Saved")
                .foregroundStyle(.black)
                .tag(SegmentState.saved)
        })
        .colorMultiply(.white)
        .colorInvert()
        .colorMultiply(.red)
        .colorInvert()
        .background(Color.white)
        .pickerStyle(.segmented)
    }
    
    @ViewBuilder
    var savedPokemonList: some View {
        if !viewModel.savedPokemon.isEmpty {
            Section {
                ForEach(viewModel.savedPokemon) { result in
                    Text(result.name.capitalized)
                        .foregroundStyle(.white)
                        .listRowBackground(Color.mint)
                }
            } header: {
                Text("Your saved Pokémon")
            }
        }
    }
    
    @ViewBuilder
    var pokemonList: some View {
        if let list = viewModel.pokemonList {
            Section {
                ForEach(list.results) { result in
                    Text(result.name.capitalized)
                        .foregroundStyle(.white)
                        .listRowBackground(Color.mint)
                }
            } header: {
                Text("Pokédex")
            }
        }
    }
}

#Preview {
    PokemonMainView()
        .environment(PokemonMainViewModel(pokemonService: PokemonService(networkService: NetworkService())))
}
