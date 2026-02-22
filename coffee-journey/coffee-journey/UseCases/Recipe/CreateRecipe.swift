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
    func callAsFunction(request: CreateRecipeRequest) throws -> Recipe {
        let recipe = Recipe(
            name: request.name,
            temperature: request.temperature,
            grindsize: request.grindSize,
            extractionTime: request.extractionTime,
            input: request.amountBeans,
            output: request.output,
            brewer: request.brewer,
            grinder: request.grinder
        )
        
        recipe.coffee = request.coffee
        return try repository.create(recipe)
    }
}
