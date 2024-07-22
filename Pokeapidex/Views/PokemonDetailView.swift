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
    private let evolotionService: EvolutionServiceProtocol
    let pokemonName: String
    var pokemon: Pokemon?
    var evolution: Evolution?
        
    init(pokemonService: PokemonServiceProtocol, evolutionService: EvolutionServiceProtocol, pokemonName: String, pokemon: Pokemon?) {
        self.pokemonService = pokemonService
        self.evolotionService = evolutionService
        self.pokemonName = pokemonName
        self.pokemon = pokemon
    }
    
    func getPokemon() async throws  {
        if pokemon == nil {
            pokemon = try await pokemonService.getPokemon(name: pokemonName)
        }
    }
    
    func getEvolution() async throws {
        guard let id = pokemon?.id else {
            return
        }
        evolution = try await evolotionService.getEvolutionChain(id: id)
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
                
                if let evolution = viewModel.evolution?.chain?.evolvesTo {
                    VStack(spacing: 8) {
                        ForEach(evolution) { chain in
                            Text(chain.species?.name ?? "")
                        }
                    }
                }
            }
            .scaledToFit()
        }
        .navigationTitle(viewModel.pokemonName.capitalized)
        .ignoresSafeArea()
        .task {
            do {
                try await viewModel.getPokemon()
                try await viewModel.getEvolution()
            } catch {
                print(error)                
            }
        }
    }
}

#Preview {
    let service = PokemonService(networkService: NetworkService())
    let evoService = EvolutionService(networkService: NetworkService())
    return PokemonDetailView()
        .environment(PokemonDetailViewModel(pokemonService: service, evolutionService: evoService, pokemonName: "rayquaza", pokemon: nil))
}
