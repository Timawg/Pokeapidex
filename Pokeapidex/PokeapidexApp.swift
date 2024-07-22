//
//  PokeapidexApp.swift
//  Pokeapidex
//
//  Created by Tim Gunnarsson on 2024-07-21.
//

import SwiftUI

enum NavigationPath: Hashable {
    case main
    case detail(_ name: String, _ pokemon: Pokemon?)
}

final class ServiceContainer {
    
    private let networkService: NetworkServiceProtocol = NetworkService()
    let pokemonService: PokemonServiceProtocol
    let evolutionService: EvolutionServiceProtocol
    
    init() {
        self.pokemonService = PokemonService(networkService: networkService)
        self.evolutionService = EvolutionService(networkService: networkService)
    }
}

@main
struct PokeapidexApp: App {

    private let serviceContainer = ServiceContainer()
    @State private var navigationPaths = [NavigationPath]()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $navigationPaths) {
                PokemonMainView(navigationPaths: $navigationPaths)
                    .environment(PokemonMainViewModel(pokemonService: serviceContainer.pokemonService))
                    .navigationDestination(for: NavigationPath.self) { path in
                        switch path {
                        case .main:
                            PokemonMainView(navigationPaths: $navigationPaths)
                                .environment(PokemonMainViewModel(pokemonService: serviceContainer.pokemonService))
                        case .detail(let name, let pokemon):
                                PokemonDetailView()
                                .environment(
                                    PokemonDetailViewModel(
                                        pokemonService: serviceContainer.pokemonService, evolutionService: serviceContainer.evolutionService, pokemonName: name, pokemon: pokemon
                                    )
                                )
                        }
                    }
            }
        }
    }
}
