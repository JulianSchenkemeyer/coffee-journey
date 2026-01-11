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

@Model final class Brew {
//    var grinder: Equipment
//    var brewer: Equipment
    
    var coffee: Coffee?
    var date: Date
    var amountCoffee: Double
    var grindSetting: Double
    var waterTemperature: Double
    var extractionTime: Int
    var taste: Double
    
    var output: Double
    var ratingString: String
    var rating: BrewRating {
        BrewRating(rawValue: ratingString) ?? .thumbsUp
    }
    
    init(date: Date, amountCoffee: Double, grindSetting: Double, waterTemperature: Double, extractionTime: Int, taste: Double, output: Double, rating: BrewRating) {
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
