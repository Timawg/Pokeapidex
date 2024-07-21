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
            Text(viewModel.randomPokemon?.name ?? "")
            List {
                if let list = viewModel.pokemonList {
                    ForEach(list.results) { pokemon in
                        Text(pokemon.name)
                    }
                }
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

#Preview {
    PokemonMainView()
        .environment(PokemonMainViewModel(pokemonService: PokemonService(networkService: NetworkService())))
}
