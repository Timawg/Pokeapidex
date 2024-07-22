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
    
    var expText: String {
        if let weight = pokemon?.baseExperience {
            return String(weight)
        } else {
           return ""
        }
    }
    
    var heightText: String {
        if let weight = pokemon?.height {
            return String(weight)
        } else {
           return ""
        }
    }
    
    var weightText: String {
        if let weight = pokemon?.weight {
            return String(weight)
        } else {
           return ""
        }
    }
    
}

struct PokemonDetailView: View {
    
    @Environment(PokemonDetailViewModel.self) var viewModel: PokemonDetailViewModel
    @State var animateGradient = false
    
    
    var body: some View {
        ZStack {
            LinearGradient(colors: viewModel.pokemon?.colors.compactMap { $0 } ?? [.green, .mint], startPoint: .topLeading, endPoint: .bottomTrailing)
                .hueRotation(.degrees(animateGradient ? 45 : 0))
            VStack(spacing: 16) {
                if let url = viewModel.url {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .imageScale(.medium)
                            .padding()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(minHeight: 400)
                }
                if let name = viewModel.pokemon?.name {
                    Text(name.capitalized)
                        .foregroundStyle(.white)
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                }
                
                if let types = viewModel.pokemon?.pokemonTypes {
                    Text(types.map { $0.rawValue.capitalized }.joined(separator: ", "))
                        .foregroundStyle(.white)
                }
                
                Divider()
                    .padding()
                HStack {
                    VStack {
                        Text("Base Stats")
                            .foregroundStyle(.white)
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.white, lineWidth: 1)
                            .shadow(color: .black, radius: 10)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 25))
                            .padding(.horizontal, 20)
                            .blur(radius: 2).overlay {
                                Text(viewModel.expText)
                                    .font(.subheadline)
                                    .foregroundStyle(.white)
                                    .shadow(color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                            }
                    }
                    VStack {
                        Text("Height")
                            .foregroundStyle(.white)
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.white, lineWidth: 1)
                            .shadow(color: .black, radius: 10)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 25))
                            .padding(.horizontal, 20)
                            .blur(radius: 2).overlay {
                                Text(viewModel.heightText)
                                    .font(.subheadline)
                                    .foregroundStyle(.white)
                                    .shadow(color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                            }
                    }
                    
                    VStack {
                        Text("Weight")
                            .foregroundStyle(.white)
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.white, lineWidth: 1)
                            .shadow(color: .black, radius: 10)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 25))
                            .padding(.horizontal, 20)
                            .blur(radius: 2).overlay {
                                    Text(viewModel.weightText)
                                    .font(.subheadline)
                                    .foregroundStyle(.white)
                                    .shadow(color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                            }
                    }
                }
                .frame(maxHeight: 100)
            }
            .scaledToFit()
        }
        .navigationTitle(viewModel.pokemonName.capitalized)
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                animateGradient.toggle()
            }
        }
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
