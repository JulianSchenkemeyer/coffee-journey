//
//  RecipeModel.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 23.11.25.
//

import Foundation

enum ShotRating: Int, Codable {
    case thumbsUp = 1
    case thumbsDown = 0
}

struct Recipe {
//    var grinder: Equipment
//    var brewer: Equipment
    
    
    var amountCoffee: Double
    var grindSetting: Double
    var waterTemperature: Double
    var extractionTime: Int
    var taste: Double
    
    var output: Double
    var rating: ShotRating
}
