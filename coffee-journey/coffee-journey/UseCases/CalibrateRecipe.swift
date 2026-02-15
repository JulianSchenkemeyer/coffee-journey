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
    func callAsFunction(brew: CalibrateRecipeRequest) throws -> Recipe {
        var recipe = brew.recipe
        
        recipe.maxTemperature = brew.temperature
        recipe.minTemperature = brew.temperature
        
        recipe.maxExtractionTime = brew.extractionTime
        recipe.minExtractionTime = brew.extractionTime
        
        recipe.maxAmountBeans = brew.amountBeans
        recipe.minAmountBeans = brew.amountBeans
        
        recipe.maxGrindSize = brew.grindSize
        recipe.minGrindSize = brew.grindSize
        
        recipe.maxOutput = brew.output
        recipe.minOutput = brew.output
        
        return try repository.update(recipe)
    }
}
