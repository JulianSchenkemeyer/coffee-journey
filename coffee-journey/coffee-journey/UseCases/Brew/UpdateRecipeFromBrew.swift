//
//  UpdateRecipeFromBrew.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 03.05.26.
//

import Foundation

@MainActor struct UpdateRecipeFromBrew {
    let recipeRepository: RecipeRepository

    @discardableResult
    func callAsFunction(recipe: Recipe, brew: Brew) throws -> Recipe {
        if brew.rating != .thumbsDown {
            recipe.lastUsed = .now
            recipe.minAmountBeans = min(recipe.minAmountBeans, brew.amountCoffee)
            recipe.maxAmountBeans = max(recipe.maxAmountBeans, brew.amountCoffee)
            recipe.minGrindSetting = min(recipe.minGrindSetting, brew.grindSetting)
            recipe.maxGrindSetting = max(recipe.maxGrindSetting, brew.grindSetting)
            recipe.minTemperature = min(recipe.minTemperature, brew.temperature)
            recipe.maxTemperature = max(recipe.maxTemperature, brew.temperature)
            recipe.minExtractionTime = min(recipe.minExtractionTime, brew.extractionTime)
            recipe.maxExtractionTime = max(recipe.maxExtractionTime, brew.extractionTime)
            recipe.minOutput = min(recipe.minOutput, brew.output)
            recipe.maxOutput = max(recipe.maxOutput, brew.output)
        }

        return try recipeRepository.update(recipe)
    }
}
