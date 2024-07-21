//
//  PokemonService.swift
//  Pokedex
//
//  Created by Tim Gunnarsson on 2024-07-21.
//

import Foundation

protocol PokemonServiceProtocol: Service {
    func getPokemonList() async throws -> PokemonList
    func getPokemon(name: String) async throws -> Pokemon
    func getPokemon(id: Int) async throws -> Pokemon
}

struct PokemonService: PokemonServiceProtocol {
    
    let baseURL: String = "https://pokeapi.co/api/v2"
    let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    enum PokemonEndpoint: Endpoint {
        
        case getPokemonList
        case getPokemonByName(String)
        case getPokemonById(Int)
                
        var path: String {
            switch self {
            case .getPokemonList:
                "/pokemon"
            case .getPokemonByName(name: let name):
                "/pokemon/\(name)"
            case .getPokemonById(id: let id):
                "/pokemon\(id)"
            }
        }
        
        var httpMethod: HTTPMethod {
            switch self {
            case .getPokemonList, .getPokemonById, .getPokemonByName: .GET
            }
        }
    }
    
    func getPokemonList() async throws -> PokemonList {
        let endpoint: PokemonEndpoint = .getPokemonList
        return try await networkService.send(request: endpoint.createURLRequest(base: baseURL))
    }
    
    func getPokemon(name: String) async throws -> Pokemon {
        let endpoint: PokemonEndpoint = .getPokemonByName(name)
        return try await networkService.send(request: endpoint.createURLRequest(base: baseURL))
    }
    
    func getPokemon(id: Int) async throws -> Pokemon {
        let endpoint: PokemonEndpoint = .getPokemonById(id)
        return try await networkService.send(request: endpoint.createURLRequest(base: baseURL))
    }
        
}
