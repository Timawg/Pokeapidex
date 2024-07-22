//
//  Evolution.swift
//  Pokeapidex
//
//  Created by Tim Gunnarsson on 2024-07-22.
//

import Foundation


// MARK: - Welcome
struct Evolution: Codable {
    let id: Int
    let chain: Chain?

    enum CodingKeys: String, CodingKey {
        case id
        case chain
    }
}

// MARK: - Chain
struct Chain: Codable, Identifiable {
    let id: UUID = .init()
    let isBaby: Bool?
    let species: Species?
    let evolutionDetails: [EvolutionDetail]?
    let evolvesTo: [Chain]?

    enum CodingKeys: String, CodingKey {
        case isBaby = "is_baby"
        case species
        case evolutionDetails = "evolution_details"
        case evolvesTo = "evolves_to"
    }
}

// MARK: - EvolutionDetail
struct EvolutionDetail: Codable {
    let trigger: Species?
    let minLevel: Int?
    let minHappiness, minBeauty, minAffection: Int?
    let needsOverworldRain: Bool?
    let timeOfDay: String?
    let tradeSpecies: Species?
    let turnUpsideDown: Bool

    enum CodingKeys: String, CodingKey {
        case trigger
        case minLevel = "min_level"
        case minHappiness = "min_happiness"
        case minBeauty = "min_beauty"
        case minAffection = "min_affection"
        case needsOverworldRain = "needs_overworld_rain"
        case timeOfDay = "time_of_day"
        case tradeSpecies = "trade_species"
        case turnUpsideDown = "turn_upside_down"
    }
}
