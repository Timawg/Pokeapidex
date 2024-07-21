//
//  ContentView.swift
//  Pokeapidex
//
//  Created by Tim Gunnarsson on 2024-07-21.
//

import SwiftUI

struct PokemonMainView: View {
    
    @State var pokemonList: PokemonList?
    @State var randomPokemon: Pokemon?
    
    let pokemonService: PokemonServiceProtocol
    
    var body: some View {
        VStack {
            Text(randomPokemon?.name ?? "")
            List {
                if let pokemonList {
                    ForEach(pokemonList.results) { pokemon in
                        Text(pokemon.name)
                    }
                }
            }
        }
        .padding()
        .task {
            do {
                pokemonList = try await pokemonService.getPokemonList()
                let random = pokemonList?.results.randomElement()?.name ?? ""
                randomPokemon = try await pokemonService.getPokemon(name: random)
            } catch {
                
            }
        }
    }
}

#Preview {
    PokemonMainView(pokemonService: PokemonService(networkService: NetworkService()))
}
