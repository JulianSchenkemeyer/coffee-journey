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

typealias Brew = SchemaV3.Brew
enum BrewClarity: Int, CaseIterable, CustomStringConvertible {
    case flat = 1
    case soft = 2
    case clean = 3
    case sharp = 4
    case harsh = 5
    
    var description: String {
        switch self {
        case .flat: "Flat / Muted"
        case .soft: "Soft"
        case .clean: "Clean"
        case .sharp: "Sharp"
        case .harsh: "Harsh / Burnt"
        }
    }
}


extension Brew {
    var tasteDescription: BrewTaste {
        BrewTaste(rawValue: taste) ?? .balanced
    }
    
    var rating: BrewRating {
        BrewRating(rawValue: ratingString) ?? .thumbsUp
    }
    
    convenience init(recipe: Recipe, date: Date, beanAge: Int?, amountCoffee: Double, grindSetting: Double, temperature: Int, extractionTime: Int, taste: Int, output: Double, rating: BrewRating) {
        self.init(
            date: date,
            beanAge: beanAge,
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
    
    convenience init(recipe: Recipe, date: Date, amountCoffee: Double, grindSetting: Double, temperature: Int, extractionTime: Int, taste: Int, output: Double, rating: BrewRating) {
        self.init(
            date: date,
            beanAge: nil,
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
