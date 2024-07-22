//
//  PokemonSearchResult.swift
//  Pokedex
//
//  Created by Tim Gunnarsson on 2024-07-21.
//

import Foundation

protocol Clonable<T> {
    associatedtype T
    func clone() -> T
}

struct PokemonList: Codable, Identifiable {
    let id: UUID = .init()
    
    let count: Int
    let next, previous: String?
    let results: [PokemonResult]
}

struct PokemonResult: Codable, Identifiable, Clonable, Equatable {
    let id: UUID = .init()
    let name: String
    let url: String
    
    func clone() -> Self {
        return .init(name: name, url: url)
    }
}
