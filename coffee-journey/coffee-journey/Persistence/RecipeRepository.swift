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
        
        do {
            try context.save()
            
            return recipe
        } catch {
            context.rollback()
            throw PersistenceError.insertFailed
        }
    }
    
    func update(_ recipe: Recipe) throws -> Recipe {
        do {
            try context.save()
            
            return recipe
        } catch {
            context.rollback()
            throw PersistenceError.updateFailed
        }
    }
    
    func delete(_ recipe: Recipe) throws {
        context.delete(recipe)
        
        do {
            try context.save()
        } catch {
            context.rollback()
            throw PersistenceError.deleteFailed
        }
    }
    
    func fetchAll() throws -> [Recipe] {
        do {
            return try context.fetch(FetchDescriptor<Recipe>())
        } catch {
            throw PersistenceError.fetchFailed
        }
    }
}

