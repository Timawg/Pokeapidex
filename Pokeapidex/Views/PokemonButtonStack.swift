//
//  PokemonButtonStack.swift
//  Pokeapidex
//
//  Created by Tim Gunnarsson on 2024-07-21.
//

import SwiftUI

struct PokemonButtonStack: View {
    
    var saved: Bool = false
    let onRandomize: () -> Void
    let onSave: () -> Void

    var body: some View {
        HStack(spacing: 16) {
            Button {
                onRandomize()
            } label: {
                RoundedRectangle(cornerSize: CGSize(width: 25, height: 25))
                    .foregroundStyle(.mint)
                    .overlay {
                        Text("Find new Pokemon")
                            .foregroundStyle(Color.white)
                    }
                    .frame(maxWidth: 250)
            }
            Button {
                onSave()
            } label: {
                Circle()
                    .foregroundStyle(.mint)
                    .overlay {
                        Image(systemName: saved ? "book.fill" : "book")
                            .foregroundStyle(Color.white)
                    }

            }
        }
    }
}

#Preview {
    PokemonButtonStack(saved: false, onRandomize: {}, onSave: {})
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: 50)
}
