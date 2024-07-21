//
//  PokeapidexApp.swift
//  Pokeapidex
//
//  Created by Tim Gunnarsson on 2024-07-21.
//

import SwiftUI

enum NavigationPath: Hashable {
    case main
    case detail
}

@main
struct PokeapidexApp: App {

    private let networkService: NetworkServiceProtocol = NetworkService()

    @State private var natigationPaths = [NavigationPath]()

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $natigationPaths) {
                PokemonMainView()
                    .environment(PokemonMainViewModel(pokemonService: PokemonService(networkService: networkService)))
                    .navigationDestination(for: NavigationPath.self) { path in
                        switch path {
                        case .main:
                            PokemonMainView()
                                .environment(PokemonMainViewModel(pokemonService: PokemonService(networkService: networkService)))
                        case .detail:
                            PokemonMainView()
                                .environment(PokemonMainViewModel(pokemonService: PokemonService(networkService: networkService)))
                        }
                    }
            }
        }
    }
}
