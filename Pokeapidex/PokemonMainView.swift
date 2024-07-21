//
//  ContentView.swift
//  Pokeapidex
//
//  Created by Tim Gunnarsson on 2024-07-21.
//

import SwiftUI
import Observation

@Observable
final class PokemonMainViewModel {
    
    private let pokemonService: PokemonServiceProtocol
    
    init(pokemonService: PokemonServiceProtocol) {
        self.pokemonService = pokemonService
    }
    
    var pokemonList: PokemonList?
    var randomPokemon: Pokemon?
    
    @MainActor
    func getPokemon() async throws {
        pokemonList = try await pokemonService.getPokemonList(limit: 10000, offset: 0)
        let random = pokemonList?.results.randomElement()?.name ?? ""
        randomPokemon = try await pokemonService.getPokemon(name: random)
    }
    
}

struct PokemonMainView: View {
    
    @Environment(PokemonMainViewModel.self) var viewModel: PokemonMainViewModel
    
    var body: some View {
        VStack {
            if let randomPokemon = viewModel.randomPokemon {
                PokemonDetailView(pokemon: randomPokemon)
            }

            if let list = viewModel.pokemonList {
                    List {
                        ForEach(list.results) { result in
                            Text(result.name.capitalized)
                                .listRowBackground(Color.mint)
                        }
                    }
                    .scrollContentBackground(.hidden)
            }
            
        }
        .padding()
        .task {
            do {
                try await viewModel.getPokemon()
            } catch {
                
            }
        }
    }
}

struct PokemonDetailView: View {
    
    private let pokemon: Pokemon
    
    init(pokemon: Pokemon) {
        self.pokemon = pokemon
    }

    var body: some View {
        VStack {
            LinearGradient(
                colors: pokemon.pokemonTypes.map { $0.color },
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
            .clipShape(.circle)
            .overlay {
                AsyncImage(url: URL(string: pokemon.sprites?.other?.officialArtwork?.frontDefault ?? "")) { image in
                    image
                        .resizable()
                        .imageScale(.medium)
                        .padding()
                } placeholder: {
                    EmptyView()
                }
            }
            .scaledToFit()
            Text(pokemon.name.capitalized)
                .font(.title)
        }
    }
}

#Preview {
    PokemonMainView()
        .environment(PokemonMainViewModel(pokemonService: PokemonService(networkService: NetworkService())))
}
