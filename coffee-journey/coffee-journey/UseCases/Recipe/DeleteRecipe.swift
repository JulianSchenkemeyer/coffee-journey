//
//  DeleteRecipe.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 17.02.26.
//

@MainActor struct DeleteRecipe {
    let repository: RecipeRepository
    
    
    func callAsFunction(recipe: Recipe) throws {
        try repository.delete(recipe)
    }
}
