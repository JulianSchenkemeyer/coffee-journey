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
    case Sour = 1
    case Bright = 2
    case Balanced = 3
    case Dry = 4
    case Bitter = 5
    
    var description: String {
        switch self.rawValue {
        case 1: "Sour"
        case 2: "Bright"
        case 3: "Balanced"
        case 4:  "Dry"
        case 5:  "Bitter"
        default: "Unknown"
        }
    }
}

@Model final class Brew {
    var coffee: Coffee?
    var recipe: Recipe?
    
    var date: Date
    var amountCoffee: Double
    var grindSetting: Double
    var waterTemperature: Double
    var extractionTime: Int
    var taste: Int
    var tasteDescription: BrewTaste {
        BrewTaste(rawValue: taste) ?? .Balanced
    }
    
    var output: Double
    var ratingString: String
    var rating: BrewRating {
        BrewRating(rawValue: ratingString) ?? .thumbsUp
    }
    
    init(date: Date, amountCoffee: Double, grindSetting: Double, waterTemperature: Double, extractionTime: Int, taste: Int, output: Double, rating: BrewRating) {
        self.date = date
        self.amountCoffee = amountCoffee
        self.grindSetting = grindSetting
        self.waterTemperature = waterTemperature
        self.extractionTime = extractionTime
        self.taste = taste
        self.output = output
        self.ratingString = rating.rawValue
    }
    
    init(recipe: Recipe, date: Date, amountCoffee: Double, grindSetting: Double, waterTemperature: Double, extractionTime: Int, taste: Int, output: Double, rating: BrewRating) {
        self.recipe = recipe
        self.date = date
        self.amountCoffee = amountCoffee
        self.grindSetting = grindSetting
        self.waterTemperature = waterTemperature
        self.extractionTime = extractionTime
        self.taste = taste
        self.output = output
        self.ratingString = rating.rawValue
    }
}
