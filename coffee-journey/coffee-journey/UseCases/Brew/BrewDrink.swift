//
//  BrewDrink.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 20.11.25.
//
import Foundation

@MainActor struct BrewDrink {
    let coffeeRepository: CoffeeRepository
    let recipeRepository: RecipeRepository
    let equipmentRepository: EquipmentRepository

    @discardableResult
    func callAsFunction(coffee: Coffee, brew: Brew, recipe: Recipe) throws -> Coffee {
        let updatedRecipe = updateRecipe(recipe, with: brew)
        brew.recipe = updatedRecipe
        _ = try recipeRepository.update(updatedRecipe)
        
        if let grinder = updatedRecipe.grinder, let brewer = updatedRecipe.brewer {
            let updatedGrinder = incrementEquipmentUses(grinder)
            _ = try equipmentRepository.update(updatedGrinder)
            
            let updatedBrewer = incrementEquipmentUses(brewer)
            _ = try equipmentRepository.update(updatedBrewer)
        }

        let updatedCoffee = updateCoffee(coffee, brewAmount: brew.amountCoffee)
        updatedCoffee.brews.append(brew)

        return try coffeeRepository.update(updatedCoffee)
    }
    
    private func incrementEquipmentUses(_ equipment: Equipment) -> Equipment {
        equipment.totalUses = (equipment.totalUses ?? 0) + 1
        equipment.usesSinceLastMaintenance = (equipment.usesSinceLastMaintenance ?? 0) + 1
        
        return equipment
    }

    private func updateRecipe(_ recipe: Recipe, with brew: Brew) -> Recipe {
        if brew.rating == .thumbsDown {
            return recipe
        }

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

        return recipe
    }

    private func updateCoffee(_ coffee: Coffee, brewAmount: Double) -> Coffee {
        coffee.totalBrews += 1
        coffee.brewsSinceRefill += 1
        coffee.amountLeft = max(0, coffee.amountLeft - brewAmount)

        return coffee
    }
}
