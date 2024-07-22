//
//  EvolutionService.swift
//  Pokedex
//
//  Created by Tim Gunnarsson on 2024-07-21.
//

import Foundation

protocol EvolutionServiceProtocol: Service {
    func getPokemonList(limit: Int, offset: Int) async throws -> PokemonList
    func getPokemon(name: String) async throws -> Pokemon
    func getPokemon(id: Int) async throws -> Pokemon
}

final class EvolutionService: Service {
    let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
        
    let baseURL: String = "https://pokeapi.co/api/v2"
    
    enum EvolutionEndpoint: Endpoint {
        
        case evolutionChain(id: String)
        case evolutionTrigger(name: String)
        
        var path: String {
            switch self {
            case .evolutionChain(id: let id):
                "/evolution-chain\(id)"
            case .evolutionTrigger(name: let name):
                "/evolution-trigger\(name)"
            }
        }
        
        var httpMethod: HTTPMethod {
            return .GET
        }
    }
}

