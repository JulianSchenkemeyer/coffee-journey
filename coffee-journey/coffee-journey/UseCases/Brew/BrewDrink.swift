//
//  BrewDrink.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 20.11.25.
//
import Foundation

@MainActor struct BrewDrink {
    let recordBrew: RecordBrew
    let updateRecipeFromBrew: UpdateRecipeFromBrew
    let incrementEquipmentUses: IncrementEquipmentUses
    let transaction: any PersistenceTransaction

    @discardableResult
    func callAsFunction(coffee: Coffee, brew: Brew, recipe: Recipe) async throws -> Coffee {
        try await transaction.perform {
            let updatedRecipe = try updateRecipeFromBrew(recipe: recipe, brew: brew)
            brew.recipe = updatedRecipe

            if let grinder = recipe.grinder, let brewer = recipe.brewer {
                try incrementEquipmentUses(equipment: grinder)
                try incrementEquipmentUses(equipment: brewer)
            }

            return try recordBrew(brew: brew, coffee: coffee)
        }
    }
}
