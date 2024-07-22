//
//  PokemonDetailView.swift
//  Pokeapidex
//
//  Created by Tim Gunnarsson on 2024-07-22.
//

import SwiftUI
import Observation

@Observable
final class PokemonDetailViewModel {
    
    private let pokemonService: PokemonServiceProtocol
    let pokemonName: String
    var pokemon: Pokemon?
        
    init(pokemonService: PokemonServiceProtocol, pokemonName: String, pokemon: Pokemon?) {
        self.pokemonService = pokemonService
        self.pokemonName = pokemonName
        self.pokemon = pokemon
    }
    
    func getPokemon() async throws  {
        if pokemon == nil {
            pokemon = try await pokemonService.getPokemon(name: pokemonName)
        }
    }
    
    var url: URL? {
        guard let urlString = pokemon?.artworkUrl, let url = URL(string: urlString) else {
            return nil
        }
        return url
    }
    
}

struct PokemonDetailView: View {
    
    @Environment(PokemonDetailViewModel.self) var viewModel: PokemonDetailViewModel
    
    var body: some View {
        ZStack {
            LinearGradient(colors: viewModel.pokemon?.colors.compactMap { $0 } ?? [.green, .mint], startPoint: .topLeading, endPoint: .bottomTrailing)
            VStack(spacing: 8) {
                if let url = viewModel.url {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .imageScale(.medium)
                            .padding()
                    } placeholder: {
                        ProgressView()
                    }
                }
                if let name = viewModel.pokemon?.name {
                    Text(name.capitalized)
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                }
                
                if let types = viewModel.pokemon?.pokemonTypes {
                    Text(types.map { $0.rawValue.capitalized }.joined(separator: ", "))
                }


            }
            .scaledToFit()
        }
        .navigationTitle(viewModel.pokemonName.capitalized)
        .ignoresSafeArea()
        .task {
            do {
                try await viewModel.getPokemon()
            } catch {
                
                
            }
        }
    }
}

#Preview {
    let service = PokemonService(networkService: NetworkService())
    return PokemonDetailView()
        .environment(PokemonDetailViewModel(pokemonService: service, pokemonName: "rayquaza", pokemon: nil))
}
