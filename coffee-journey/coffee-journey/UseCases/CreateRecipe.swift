//
//  CreateRecipe.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 01.02.26.
//
import Foundation
import SwiftData


@MainActor struct CreateRecipe {
    let repository: RecipeRepository
    
    @discardableResult
    func callAsFunction(newRecipe: CreateRecipeRequest) throws -> Recipe {
        let recipe = Recipe(
            name: newRecipe.name,
            temperature: newRecipe.temperature,
            grindsize: newRecipe.grindSize,
            extractionTime: newRecipe.extractionTime,
            input: newRecipe.amountBeans,
            output: newRecipe.output
        )
        
        return try repository.create(recipe)
    }
}
