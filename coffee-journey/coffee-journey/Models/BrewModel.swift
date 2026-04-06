//
//  RecipeModel.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 23.11.25.
//

import Foundation
import SwiftData

enum BrewRating: String, Codable, CustomStringConvertible {
    case thumbsUp = "Good"
    case thumbsDown = "Bad"
    
    var description: String { self.rawValue }
}

enum BrewTaste: Int, CaseIterable, CustomStringConvertible {
    case sour = 1
    case bright = 2
    case balanced = 3
    case dry = 4
    case bitter = 5
    
    var description: String {
        switch self {
        case .sour: "Sour"
        case .bright: "Bright"
        case .balanced: "Balanced"
        case .dry: "Dry"
        case .bitter: "Bitter"
        }
    }
}

typealias Brew = SchemaV2.Brew


extension Brew {
    var tasteDescription: BrewTaste {
        BrewTaste(rawValue: taste) ?? .balanced
    }
    
    var rating: BrewRating {
        BrewRating(rawValue: ratingString) ?? .thumbsUp
    }
    
    convenience init(recipe: Recipe, date: Date, amountCoffee: Double, grindSetting: Double, temperature: Int, extractionTime: Int, taste: Int, output: Double, rating: BrewRating) {
        
        self.init(
            date: date,
            amountCoffee: amountCoffee,
            grindSetting: grindSetting,
            temperature: temperature,
            extractionTime: extractionTime,
            taste: taste,
            output: output,
            rating: rating
        )
        self.recipe = recipe
    }
}
