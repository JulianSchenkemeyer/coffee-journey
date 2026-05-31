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
    private let persistenceContext: SwiftDataPersistenceContext
    private var context: ModelContext { persistenceContext.modelContext }

    init(persistenceContext: SwiftDataPersistenceContext) {
        self.persistenceContext = persistenceContext
    }

    func create(_ recipe: Recipe) throws -> Recipe {
        context.insert(recipe)
        try persistenceContext.commitOrDefer(onFailure: .insertFailed)
        return recipe
    }

    func update(_ recipe: Recipe) throws -> Recipe {
        try persistenceContext.commitOrDefer(onFailure: .updateFailed)
        return recipe
    }

    func delete(_ recipe: Recipe) throws {
        context.delete(recipe)
        try persistenceContext.commitOrDefer(onFailure: .deleteFailed)
    }
    
    func fetchAll() throws -> [Recipe] {
        do {
            return try context.fetch(FetchDescriptor<Recipe>())
        } catch {
            throw PersistenceError.fetchFailed
        }
    }
}

