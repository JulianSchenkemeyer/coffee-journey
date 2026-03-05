//
//  UpdateRecipe.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 15.02.26.
//
import Foundation
import SwiftData


@MainActor struct UpdateRecipe {
    let repository: RecipeRepository

    @discardableResult
    func callAsFunction(recipe: Recipe, request: UpdateRecipeRequest) throws -> Recipe {
        recipe.name = request.name
        recipe.brewer = request.brewer
        recipe.grinder = request.grinder
        recipe.minTemperature = request.temperature
        recipe.maxTemperature = request.temperature
        recipe.minGrindSetting = request.grindSetting
        recipe.maxGrindSetting = request.grindSetting
        recipe.minExtractionTime = request.extractionTime
        recipe.maxExtractionTime = request.extractionTime
        recipe.minAmountBeans = request.amountBeans
        recipe.maxAmountBeans = request.amountBeans
        recipe.minOutput = request.output
        recipe.maxOutput = request.output
        return try repository.update(recipe)
    }
}
