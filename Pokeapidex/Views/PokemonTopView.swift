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
    @State var imageOffset: CGFloat = 0
    @State var animateGradient: Bool = false
    
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
            .animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/, value: urlString)
            .hueRotation(.degrees(animateGradient ? 45 : 0))
            .clipShape(.circle)
            .overlay {
                VStack {
                    if let urlString,
                       let url = URL(string: urlString) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .imageScale(.medium)
                                .offset(x: imageOffset)
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
        .onChange(of: urlString) { oldValue, newValue in
            animateImage()
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                animateGradient.toggle()
            }
        }
    }
    
    func animateImage() {                
        withAnimation(.easeInOut(duration: 0.1)) {
            imageOffset = -300
        } completion: {
            imageOffset = 600
            withAnimation(.easeInOut(duration: 1.0)) {
                imageOffset = 0
            }
        }
    }
}
