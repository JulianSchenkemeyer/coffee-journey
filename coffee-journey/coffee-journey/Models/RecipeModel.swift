//
//  RecipeModel.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 18.01.26.
//
import Foundation
import SwiftData


typealias Recipe = SchemaV3.Recipe


extension Recipe {
    var temperature: Int {
        ((minTemperature + maxTemperature) / 2)
    }
    
    var grindSetting: Double {
        // Depends Grinder
        if (false) {
            ((minGrindSetting + maxGrindSetting) / 2).roundTo(places: 1)
        } else {
            ((minGrindSetting + maxGrindSetting) / 2).rounded()
        }
    }
    
    var extractionTime: Int {
        (minExtractionTime + maxExtractionTime) / 2
    }
    
    var amountBeans: Double {
        ((minAmountBeans + maxAmountBeans) / 2).roundTo(places: 1)
    }
    
    var output: Double {
        ((minOutput + maxOutput) / 2).roundTo(places: 1)
    }
    
    convenience init(
        name: String,
        temperature: Int,
        grindSetting: Double,
        extractionTime: Int,
        input: Double,
        output: Double,
        brewer: Equipment? = nil,
        grinder: Equipment? = nil
    ) {
        self.init(
            name: name,
            minTemperature: temperature,
            maxTemperature: temperature,
            minGrindSetting: grindSetting,
            maxGrindSetting: grindSetting,
            minExtractionTime: extractionTime,
            maxExtractionTime: extractionTime,
            minBeans: input,
            maxBeans: input,
            minOutput: output,
            maxOutput: output,
            brewer: brewer,
            grinder: grinder
        )
    }
}

