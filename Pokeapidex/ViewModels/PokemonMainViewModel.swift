//
//  PokemonMainViewModel.swift
//  Pokeapidex
//
//  Created by Tim Gunnarsson on 2024-07-21.
//

import Foundation
import Observation

enum SegmentState: Int {
    case pokedex
    case saved
}

@Observable
final class PokemonMainViewModel {
    
    private let pokemonService: PokemonServiceProtocol
    private static let userDefaults = UserDefaults.standard
    private static let savedPokemonKey = "saved_pokemon"
    
    init(pokemonService: PokemonServiceProtocol) {
        self.pokemonService = pokemonService
    }
    
    var pokemonList: PokemonList?
    var randomPokemon: Pokemon?
    var savedPokemon: [Pokemon] = getSavedPokemon()
    
    @MainActor
    func getPokemon() async throws {
        try await getAllPokemon()
        try await randomizePokemon()
    }
    
    @MainActor
    func getAllPokemon() async throws {
        pokemonList = try await pokemonService.getPokemonList(limit: 10000, offset: 0)
    }
    
    @MainActor
    func randomizePokemon() async throws {
        guard let random = pokemonList?.results.randomElement()?.name else {
            return
        }
        
        randomPokemon = try await pokemonService.getPokemon(name: random)
    }
    
    func save(pokemon: Pokemon) {
        if let index = savedPokemon.firstIndex(where: { $0.id == pokemon.id }) {
            savedPokemon.remove(at: index)
        } else {
            savedPokemon.append(pokemon)
        }

        do {
            let encoded = try JSONEncoder().encode(savedPokemon)
            Self.userDefaults.set(encoded, forKey: Self.savedPokemonKey)
        } catch {
            // Handle save failed
        }
    }
    
    func isSaved(pokemon: Pokemon) -> Bool {
        return savedPokemon.contains { $0.id == pokemon.id }
    }
    
    private static func getSavedPokemon() -> [Pokemon] {
        guard let data = Self.userDefaults.data(forKey: savedPokemonKey) else {
            return []
        }
        guard let decoded = try? JSONDecoder().decode([Pokemon].self, from: data) else {
            return []
        }
        return decoded
    }
}
