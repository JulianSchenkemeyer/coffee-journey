//
//  Brew.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 20.11.25.
//
import Foundation

@MainActor struct BrewDrink {
    let repository: CoffeeRepository
    
    @discardableResult
    func callAsFunction(coffee: Coffee, brew: Brew, recipe: Recipe) throws -> Coffee {
        let updatedRecipe = updateRecipe(recipe, with: brew)
        brew.recipe = updatedRecipe
        
        let updatedCoffee = updateCoffee(coffee, brewAmount: brew.amountCoffee)
        updatedCoffee.brews.append(brew)
        
        return try repository.update(updatedCoffee)
    }
    
    private func updateRecipe(_ recipe: Recipe, with brew: Brew) -> Recipe {
        if (brew.rating == .thumbsDown) {
            return recipe
        }
        
        recipe.lastUsed = .now
        recipe.minAmountBeans = min(recipe.minAmountBeans, brew.amountCoffee)
        recipe.maxAmountBeans = max(recipe.maxAmountBeans, brew.amountCoffee)
        recipe.minGrindSize = min(recipe.minGrindSize, brew.grindSetting)
        recipe.maxGrindSize = max(recipe.maxGrindSize, brew.grindSetting)
        recipe.minTemperature = min(recipe.minTemperature, brew.waterTemperature)
        recipe.maxTemperature = max(recipe.maxTemperature, brew.waterTemperature)
        recipe.minExtractionTime = min(recipe.minExtractionTime, brew.extractionTime)
        recipe.maxExtractionTime = max(recipe.maxExtractionTime, brew.extractionTime)
        recipe.minOutput = min(recipe.minOutput, brew.output)
        recipe.maxOutput = max(recipe.maxOutput, brew.output)
        
        return recipe
    }
    
    private func updateCoffee(_ coffee: Coffee, brewAmount: Double) -> Coffee {
        coffee.totalBrews += 1
        coffee.brewsSinceRefill += 1
        coffee.amountLeft = max(0, coffee.amountLeft - brewAmount)
        
        return coffee
    }
}
