//
//  PokemonTopView.swift
//  Pokeapidex
//
//  Created by Tim Gunnarsson on 2024-07-22.
//

import SwiftUI

struct PokemonTopView: View {
    
    private let name: String
    private let urlString: String?
    private let colors: [Color]
    
    init(name: String, urlString: String?, colors: [Color]) {
        self.name = name
        self.urlString = urlString
        self.colors = colors
    }
    
    var body: some View {
        VStack(spacing: 16) {
            LinearGradient(
                colors: colors,
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
            .animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/, value: colors)
            .clipShape(.circle)
            .overlay {
                VStack {
                    if let urlString,
                       let url = URL(string: urlString) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .imageScale(.medium)
                                .padding()
                        } placeholder: {
                            ProgressView()
                        }
                    }
                }
            }
            .scaledToFit()
            Text(name.capitalized)
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
        }
    }
}
