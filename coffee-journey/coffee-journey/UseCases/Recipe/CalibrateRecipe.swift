//
//  CalibrateRecipe.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 15.02.26.
//
import Foundation


@MainActor struct CalibrateRecipe {
    let repository: RecipeRepository
    
    @discardableResult
    func callAsFunction(request: CalibrateRecipeRequest) throws -> Recipe {
        let recipe = request.recipe
        
        recipe.maxTemperature = request.temperature
        recipe.minTemperature = request.temperature
        
        recipe.maxExtractionTime = request.extractionTime
        recipe.minExtractionTime = request.extractionTime
        
        recipe.maxAmountBeans = request.amountBeans
        recipe.minAmountBeans = request.amountBeans
        
        recipe.maxGrindSetting = request.grindSetting
        recipe.minGrindSetting = request.grindSetting
        
        recipe.maxOutput = request.output
        recipe.minOutput = request.output
        
        return try repository.update(recipe)
    }
}
