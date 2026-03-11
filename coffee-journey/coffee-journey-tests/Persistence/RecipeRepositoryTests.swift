//
//  RecipeRepositoryTests.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 11.03.26.
//
import Foundation
import Testing
import SwiftData
@testable import coffee_journey


@MainActor
struct SwiftDataRecipeRepositoryTests {

    // MARK: - Helpers

    private func prepareEnvironment() throws -> (SwiftDataRecipeRepository, ModelContext) {
        let container = ContainerFactory.createInMemory()
        let context = ModelContext(container)
        let repository = SwiftDataRecipeRepository(context: context)
        return (repository, context)
    }

    @discardableResult
    private func insertRecipe(name: String = "Espresso", into context: ModelContext) throws -> Recipe {
        let recipe = Recipe(
            name: name,
            minTemperature: 90,
            maxTemperature: 96,
            minGrindSetting: 8.0,
            maxGrindSetting: 10.0,
            minExtractionTime: 25,
            maxExtractionTime: 35,
            minBeans: 17.0,
            maxBeans: 19.0,
            minOutput: 30.0,
            maxOutput: 36.0
        )
        context.insert(recipe)
        try context.save()
        return recipe
    }

    // MARK: - Create

    @Test func createPersistsRecipe() throws {
        let (repository, context) = try prepareEnvironment()
        let recipe = Recipe(
            name: "Flat White",
            temperature: 93,
            grindSetting: 9.0,
            extractionTime: 28,
            input: 18.0,
            output: 36.0
        )

        let created = try repository.create(recipe)

        let all = try context.fetch(FetchDescriptor<Recipe>())
        #expect(all.count == 1)
        #expect(created.name == "Flat White")
        #expect(created.minTemperature == 93)
        #expect(created.maxTemperature == 93)
    }

    @Test func createReturnsTheSameRecipe() throws {
        let (repository, _) = try prepareEnvironment()
        let recipe = Recipe(
            name: "Flat White",
            temperature: 93,
            grindSetting: 9.0,
            extractionTime: 28,
            input: 18.0,
            output: 36.0
        )

        let created = try repository.create(recipe)

        #expect(created.persistentModelID == recipe.persistentModelID)
    }

    // MARK: - FetchAll

    @Test func fetchAllReturnsAllRecipes() throws {
        let (repository, context) = try prepareEnvironment()
        try insertRecipe(name: "Espresso", into: context)
        try insertRecipe(name: "Filter", into: context)

        let result = try repository.fetchAll()

        #expect(result.count == 2)
    }

    @Test func fetchAllReturnsEmptyWhenStoreIsEmpty() throws {
        let (repository, _) = try prepareEnvironment()

        let result = try repository.fetchAll()

        #expect(result.isEmpty)
    }

    // MARK: - Update

    @Test func updatePersistsChanges() throws {
        let (repository, context) = try prepareEnvironment()
        let recipe = try insertRecipe(into: context)

        recipe.name = "Updated Espresso"
        recipe.minTemperature = 92
        recipe.maxTemperature = 94
        let updated = try repository.update(recipe)

        let fetched = context.model(for: recipe.persistentModelID) as? Recipe
        #expect(updated.name == "Updated Espresso")
        #expect(fetched?.name == "Updated Espresso")
        #expect(fetched?.minTemperature == 92)
        #expect(fetched?.maxTemperature == 94)
    }

    @Test func updateReturnsTheSameRecipe() throws {
        let (repository, context) = try prepareEnvironment()
        let recipe = try insertRecipe(into: context)

        let result = try repository.update(recipe)

        #expect(result.persistentModelID == recipe.persistentModelID)
    }

    // MARK: - Delete

    @Test func deleteRemovesRecipeFromStore() throws {
        let (repository, context) = try prepareEnvironment()
        let recipe = try insertRecipe(into: context)

        try repository.delete(recipe)

        let remaining = try context.fetch(FetchDescriptor<Recipe>())
        #expect(remaining.isEmpty)
    }

    @Test func deletingNonExistentRecipeDoesNotThrow() throws {
        let (repository, context) = try prepareEnvironment()
        let recipe = try insertRecipe(into: context)
        context.delete(recipe)          // delete directly, without saving
        try context.save()

        #expect(throws: Never.self) {
            try repository.delete(recipe)
        }
    }
}
