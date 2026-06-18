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

typealias Brew = SchemaV4.Brew


extension Brew {
    var tasteDescription: BrewTaste {
        BrewTaste(rawValue: taste) ?? .balanced
    }
    
    var clarityDescription: BrewClarity {
        guard let clarity else { return .clean }
        return BrewClarity(rawValue: clarity) ?? .clean
    }
    
    var ratio: Double? {
        guard amountCoffee > 0 else { return nil }
        return output / amountCoffee
    }
    
    var flowRate: Double? {
        guard extractionTime > 0 else { return nil }
        return output / Double(extractionTime)
    }
    
    var rating: BrewRating {
        BrewRating(rawValue: ratingString) ?? .thumbsUp
    }
    
    convenience init(recipe: Recipe, date: Date, beanAge: Int?, amountCoffee: Double, grindSetting: Double, temperature: Int, extractionTime: Int, taste: Int, output: Double, rating: BrewRating, clarity: Int? = nil) {
        self.init(
            date: date,
            beanAge: beanAge,
            amountCoffee: amountCoffee,
            grindSetting: grindSetting,
            temperature: temperature,
            extractionTime: extractionTime,
            taste: taste,
            output: output,
            rating: rating,
            clarity: clarity
        )
        self.recipe = recipe
    }
    
    convenience init(recipe: Recipe, date: Date, amountCoffee: Double, grindSetting: Double, temperature: Int, extractionTime: Int, taste: Int, output: Double, rating: BrewRating, clarity: Int? = nil) {
        self.init(
            date: date,
            beanAge: nil,
            amountCoffee: amountCoffee,
            grindSetting: grindSetting,
            temperature: temperature,
            extractionTime: extractionTime,
            taste: taste,
            output: output,
            rating: rating,
            clarity: clarity
        )
        self.recipe = recipe
    }
}
