//
//  RecipeModel.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 18.01.26.
//
import Foundation
import SwiftData



@Model
final class Recipe: Identifiable {
    var brews: [Brew] = []
    var coffee: Coffee?
    
    //TODO: Equipement creation
//    var brewer: Equipment
//    var grinder: Equipment
    
    var name: String
    
    var minTemperature: Double
    var maxTemperature: Double
    var temperature: Double {
        ((minTemperature + maxTemperature) / 2).roundTo(places: 1)
    }
    
    var minGrindSize: Double
    var maxGrindSize: Double
    var grindSize: Double {
        // Depends Grinder
        if (false) {
            ((minGrindSize + maxGrindSize) / 2).roundTo(places: 1)
        } else {
            ((minGrindSize + maxGrindSize) / 2).rounded()
        }
    }
    
    var minExtractionTime: Int
    var maxExtractionTime: Int
    var extractionTime: Int {
        (minExtractionTime + maxExtractionTime) / 2
    }
    
    var minAmountBeans: Double
    var maxAmountBeans: Double
    var amountBeans: Double {
        ((minAmountBeans + maxAmountBeans) / 2).roundTo(places: 1)
    }
    
    
    var minOutput: Double
    var maxOutput: Double
    var output: Double {
        ((minOutput + maxOutput) / 2).roundTo(places: 1)
    }
    
    
    init(name: String, minTemperature: Double, maxTemperature: Double, minGrindSize: Double, maxGrindSize: Double, minExtractionTime: Int, maxExtractionTime: Int, minBeans: Double, maxBeans: Double, minOutput: Double, maxOutput: Double) {
//        self.brewer = brewer
//        self.grinder = grinder
        self.name = name
        self.minTemperature = minTemperature
        self.maxTemperature = maxTemperature
        self.minGrindSize = minGrindSize
        self.maxGrindSize = maxGrindSize
        self.minExtractionTime = minExtractionTime
        self.maxExtractionTime = maxExtractionTime
        self.minAmountBeans = minBeans
        self.maxAmountBeans = maxBeans
        self.minOutput = minOutput
        self.maxOutput = maxOutput
    }
    
    init(name: String, temperature: Double, grindsize: Double, extractionTime: Int, input: Double, output: Double) {
//        self.brewer = brewer
//        self.grinder = grinder
        self.name = name
        self.minTemperature = temperature
        self.maxTemperature = temperature
        self.minGrindSize = grindsize
        self.maxGrindSize = grindsize
        self.minExtractionTime = extractionTime
        self.maxExtractionTime = extractionTime
        self.minAmountBeans = input
        self.maxAmountBeans = input
        self.minOutput = output
        self.maxOutput = output
    }
}

