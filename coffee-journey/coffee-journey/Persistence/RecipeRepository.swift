//
//  RecipeRepository.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 01.02.26.
//
import Foundation
import SwiftData


protocol RecipeRepository {
    func create(_ recipe: Recipe) throws -> Recipe
    func fetchAll() throws -> [Recipe]
    func update(_ recipe: Recipe) throws -> Recipe
    func delete(_ recipe: Recipe) throws
}

@MainActor
final class SwiftDataRecipeRepository: RecipeRepository {
    private let context: ModelContext
    init(context: ModelContext) { self.context = context }
    
    func create(_ recipe: Recipe) throws -> Recipe {
        context.insert(recipe)
        try context.save()
        
        return recipe
    }
    
    func fetchAll() throws -> [Recipe] {
        try context.fetch(FetchDescriptor<Recipe>())
    }
    
    func update(_ recipe: Recipe) throws -> Recipe {
        try context.save()
        
        return recipe
    }
    
    func delete(_ recipe: Recipe) throws {
        context.delete(recipe)
        try context.save()
    }
}

