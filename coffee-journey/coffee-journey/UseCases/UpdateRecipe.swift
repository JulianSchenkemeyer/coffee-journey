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
    func callAsFunction(recipe: Recipe) throws -> Recipe {
        return try repository.update(recipe)
    }
}
