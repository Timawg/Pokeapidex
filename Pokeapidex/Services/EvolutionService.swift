//
//  EvolutionService.swift
//  Pokedex
//
//  Created by Tim Gunnarsson on 2024-07-21.
//

import Foundation

protocol EvolutionServiceProtocol: Service {
    func getEvolutionChain(id: Int) async throws -> Evolution
}

final class EvolutionService: EvolutionServiceProtocol {
    
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
                "/evolution-chain/\(id)"
            case .evolutionTrigger(name: let name):
                "/evolution-trigger/\(name)"
            }
        }
        
        var httpMethod: HTTPMethod {
            return .GET
        }
    }
    
    func getEvolutionChain(id: Int) async throws -> Evolution {
        let endpoint = EvolutionEndpoint.evolutionChain(id: "\(id)")
        return try await networkService.send(request: endpoint.createURLRequest(base: baseURL))
    }
}

