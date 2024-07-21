//
//  Color + PokemonType.swift
//  Pokeapidex
//
//  Created by Tim Gunnarsson on 2024-07-21.
//

import Foundation
import SwiftUI

extension PokemonType {
    
    var color: Color {
            switch self {
            case .normal:
                return .white
            case .fire:
                return .red
            case .water:
                return .blue
            case .grass:
                return .green
            case .electric:
                return .yellow
            case .ice:
                return .cyan
            case .fighting:
                return .brown
            case .poison:
                return .purple
            case .ground:
                return .teal
            case .flying:
                return .gray
            case .psychic:
                return .pink
            case .bug:
                return .mint
            case .rock:
                return .brown
            case .ghost:
                return .indigo
            case .dragon:
                return .red
            case .dark:
                return .black
            case .steel:
                return .gray
            case .fairy:
                return .pink
            }
        }
}
