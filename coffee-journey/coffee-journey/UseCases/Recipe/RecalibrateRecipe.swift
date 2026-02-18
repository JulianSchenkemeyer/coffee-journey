//
//  RecalibrateRecipe.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 01.02.26.
//
import Foundation


@MainActor struct RecalibrateRecipe {
    let repository: RecipeRepository
    
    
    @discardableResult
    func callAsFunction(recipe: Recipe) throws -> Recipe {
        let avgTemperature = recipe.temperature
        recipe.maxTemperature = avgTemperature
        recipe.minTemperature = avgTemperature
        
        let avgExtractionTime = recipe.extractionTime
        recipe.maxExtractionTime = avgExtractionTime
        recipe.minExtractionTime = avgExtractionTime
        
        let avgAmountBeans = recipe.amountBeans
        recipe.maxAmountBeans = avgAmountBeans
        recipe.minAmountBeans = avgAmountBeans
        
        let avgGrindSize = recipe.grindSize
        recipe.maxGrindSize = avgGrindSize
        recipe.minGrindSize = avgGrindSize
        
        let avgOutput = recipe.output
        recipe.maxOutput = avgOutput
        recipe.minOutput = avgOutput
        
        return try repository.update(recipe)
    }
}
