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

@Model final class Brew {
    var coffee: Coffee?
    var recipe: Recipe?
    
    var date: Date
    var amountCoffee: Double
    var grindSetting: Double
    var temperature: Int
    var extractionTime: Int
    var taste: Int
    var tasteDescription: BrewTaste {
        BrewTaste(rawValue: taste) ?? .balanced
    }
    
    var output: Double
    var ratingString: String
    var rating: BrewRating {
        BrewRating(rawValue: ratingString) ?? .thumbsUp
    }
    
    init(date: Date, amountCoffee: Double, grindSetting: Double, temperature: Int, extractionTime: Int, taste: Int, output: Double, rating: BrewRating) {
        self.date = date
        self.amountCoffee = amountCoffee
        self.grindSetting = grindSetting
        self.temperature = temperature
        self.extractionTime = extractionTime
        self.taste = taste
        self.output = output
        self.ratingString = rating.rawValue
    }
    
    init(recipe: Recipe, date: Date, amountCoffee: Double, grindSetting: Double, temperature: Int, extractionTime: Int, taste: Int, output: Double, rating: BrewRating) {
        self.recipe = recipe
        self.date = date
        self.amountCoffee = amountCoffee
        self.grindSetting = grindSetting
        self.temperature = temperature
        self.extractionTime = extractionTime
        self.taste = taste
        self.output = output
        self.ratingString = rating.rawValue
    }
}
