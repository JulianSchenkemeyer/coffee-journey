//
//  RecipeModel.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 23.11.25.
//

import Foundation
import SwiftData

enum BrewRating: String, Codable, CustomStringConvertible {
    case thumbsUp = "GOOD"
    case thumbsDown = "BAD"
    
    var description: String { self.rawValue }
}

@Model final class Brew {
//    var grinder: Equipment
//    var brewer: Equipment
    
    var coffee: Coffee?
    var amountCoffee: Double
    var grindSetting: Double
    var waterTemperature: Double
    var extractionTime: Int
    var taste: Double
    
    var output: Double
    var rating: BrewRating
    
    init(amountCoffee: Double, grindSetting: Double, waterTemperature: Double, extractionTime: Int, taste: Double, output: Double, rating: BrewRating) {
        self.amountCoffee = amountCoffee
        self.grindSetting = grindSetting
        self.waterTemperature = waterTemperature
        self.extractionTime = extractionTime
        self.taste = taste
        self.output = output
        self.rating = rating
    }
}
