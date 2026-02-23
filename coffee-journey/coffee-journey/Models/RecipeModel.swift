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
    @Relationship(deleteRule: .nullify, inverse: \Brew.recipe) var brews: [Brew] = []
    var coffee: Coffee?
    
    @Relationship(deleteRule: .nullify, inverse: \Equipment.brewerRecipes) var brewer: Equipment?
    @Relationship(deleteRule: .nullify, inverse: \Equipment.grinderRecipes) var grinder: Equipment?
    
    var name: String
    var lastUsed: Date?
    
    var minTemperature: Int
    var maxTemperature: Int
    var temperature: Int {
        ((minTemperature + maxTemperature) / 2)
    }
    
    var minGrindSetting: Double
    var maxGrindSetting: Double
    var grindSetting: Double {
        // Depends Grinder
        if (false) {
            ((minGrindSetting + maxGrindSetting) / 2).roundTo(places: 1)
        } else {
            ((minGrindSetting + maxGrindSetting) / 2).rounded()
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
    
    
    init(
        name: String,
        minTemperature: Int,
        maxTemperature: Int,
        minGrindSetting: Double,
        maxGrindSetting: Double,
        minExtractionTime: Int,
        maxExtractionTime: Int,
        minBeans: Double,
        maxBeans: Double,
        minOutput: Double,
        maxOutput: Double,
        brewer: Equipment? = nil,
        grinder: Equipment? = nil
    ) {
        self.brewer = brewer
        self.grinder = grinder
        self.name = name
        self.minTemperature = minTemperature
        self.maxTemperature = maxTemperature
        self.minGrindSetting = minGrindSetting
        self.maxGrindSetting = maxGrindSetting
        self.minExtractionTime = minExtractionTime
        self.maxExtractionTime = maxExtractionTime
        self.minAmountBeans = minBeans
        self.maxAmountBeans = maxBeans
        self.minOutput = minOutput
        self.maxOutput = maxOutput
    }
    
    init(
        name: String,
        temperature: Int,
        grindSetting: Double,
        extractionTime: Int,
        input: Double,
        output: Double,
        brewer: Equipment? = nil,
        grinder: Equipment? = nil
    ) {
        self.brewer = brewer
        self.grinder = grinder
        self.name = name
        self.minTemperature = temperature
        self.maxTemperature = temperature
        self.minGrindSetting = grindSetting
        self.maxGrindSetting = grindSetting
        self.minExtractionTime = extractionTime
        self.maxExtractionTime = extractionTime
        self.minAmountBeans = input
        self.maxAmountBeans = input
        self.minOutput = output
        self.maxOutput = output
    }
}

