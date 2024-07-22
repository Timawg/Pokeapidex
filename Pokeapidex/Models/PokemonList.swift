//
//  PokemonSearchResult.swift
//  Pokedex
//
//  Created by Tim Gunnarsson on 2024-07-21.
//

import Foundation

struct PokemonList: Codable, Identifiable {
    let id: UUID = .init()
    
    let count: Int
    let next, previous: String?
    let results: [PokemonResult]
}

struct PokemonResult: Codable, Identifiable, Equatable {
    let id: UUID = .init()
    let name: String
    let url: String
}
