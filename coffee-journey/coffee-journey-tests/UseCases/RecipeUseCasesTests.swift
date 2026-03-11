//
//  RecipeUseCasesTests.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 11.03.26.
//
import Foundation
import Testing
import SwiftData
@testable import coffee_journey


@MainActor
struct RecipeUseCasesTests {

    // MARK: - Helpers

    private func prepareEnvironment() throws -> (SwiftDataRecipeRepository, ModelContext) {
        let container = ContainerFactory.createInMemory()
        let context = ModelContext(container)
        let repository = SwiftDataRecipeRepository(context: context)
        return (repository, context)
    }

    private func makeCoffee(into context: ModelContext) -> Coffee {
        let coffee = Coffee(
            name: "Ethiopia",
            roaster: "Blue Bottle",
            roastCategory: RoastCategory.light.rawValue,
            amount: 250.0,
            amountLeft: 250.0,
            lastRefill: .now,
            brews: [],
            recipes: [],
            totalBrews: 0,
            brewsSinceRefill: 0,
            roastDate: .now,
            rating: 0.0,
            notes: ""
        )
        context.insert(coffee)
        return coffee
    }

    // A recipe with a wide range to give calibration tests room to work with
    private func makeWideRecipe(into context: ModelContext) -> Recipe {
        let recipe = Recipe(
            name: "Espresso",
            minTemperature: 88,
            maxTemperature: 98,
            minGrindSetting: 7.0,
            maxGrindSetting: 12.0,
            minExtractionTime: 22,
            maxExtractionTime: 38,
            minBeans: 16.0,
            maxBeans: 20.0,
            minOutput: 28.0,
            maxOutput: 40.0
        )
        context.insert(recipe)
        return recipe
    }

    private func makeCreateRequest(coffee: Coffee) -> CreateRecipeRequest {
        CreateRecipeRequest(
            grinder: nil,
            brewer: nil,
            coffee: coffee,
            name: "Filter",
            temperature: 94,
            grindSetting: 20.0,
            extractionTime: 240,
            amountBeans: 15.0,
            output: 250.0
        )
    }

    // MARK: - CreateRecipe

    @Test func createRecipePersistsRecipe() throws {
        let (repository, context) = try prepareEnvironment()
        let useCase = CreateRecipe(repository: repository)
        let coffee = makeCoffee(into: context)

        try useCase(request: makeCreateRequest(coffee: coffee))

        let all = try context.fetch(FetchDescriptor<Recipe>())
        #expect(all.count == 1)
    }

    @Test func createRecipeMapsRequestFields() throws {
        let (repository, context) = try prepareEnvironment()
        let useCase = CreateRecipe(repository: repository)
        let coffee = makeCoffee(into: context)

        let created = try useCase(request: makeCreateRequest(coffee: coffee))

        #expect(created.name == "Filter")
        #expect(created.minTemperature == 94)
        #expect(created.maxTemperature == 94)
        #expect(created.minGrindSetting == 20.0)
        #expect(created.maxGrindSetting == 20.0)
        #expect(created.minAmountBeans == 15.0)
        #expect(created.maxAmountBeans == 15.0)
        #expect(created.minOutput == 250.0)
        #expect(created.maxOutput == 250.0)
        #expect(created.coffee?.persistentModelID == coffee.persistentModelID)
    }

    @Test func createRecipeReturnsCreatedRecipe() throws {
        let (repository, context) = try prepareEnvironment()
        let useCase = CreateRecipe(repository: repository)
        let coffee = makeCoffee(into: context)

        let created = try useCase(request: makeCreateRequest(coffee: coffee))

        #expect(created.name == "Filter")
    }

    // MARK: - UpdateRecipe

    @Test func updateRecipeAppliesRequestFields() throws {
        let (repository, context) = try prepareEnvironment()
        let useCase = UpdateRecipe(repository: repository)
        let recipe = makeWideRecipe(into: context)
        let request = UpdateRecipeRequest(
            name: "Updated Espresso",
            brewer: nil,
            grinder: nil,
            temperature: 93,
            grindSetting: 9.5,
            extractionTime: 30,
            amountBeans: 18.0,
            output: 36.0
        )

        try useCase(recipe: recipe, request: request)

        #expect(recipe.name == "Updated Espresso")
        #expect(recipe.minTemperature == 93)
        #expect(recipe.maxTemperature == 93)
        #expect(recipe.minGrindSetting == 9.5)
        #expect(recipe.maxGrindSetting == 9.5)
        #expect(recipe.minExtractionTime == 30)
        #expect(recipe.maxExtractionTime == 30)
        #expect(recipe.minAmountBeans == 18.0)
        #expect(recipe.maxAmountBeans == 18.0)
        #expect(recipe.minOutput == 36.0)
        #expect(recipe.maxOutput == 36.0)
    }

    @Test func updateRecipeCollapsesRangesToSingleValue() throws {
        let (repository, context) = try prepareEnvironment()
        let useCase = UpdateRecipe(repository: repository)
        let recipe = makeWideRecipe(into: context)  // starts with wide ranges
        let request = UpdateRecipeRequest(
            name: "Espresso",
            brewer: nil,
            grinder: nil,
            temperature: 93,
            grindSetting: 9.0,
            extractionTime: 30,
            amountBeans: 18.0,
            output: 33.0
        )

        try useCase(recipe: recipe, request: request)

        #expect(recipe.minTemperature == recipe.maxTemperature)
        #expect(recipe.minGrindSetting == recipe.maxGrindSetting)
        #expect(recipe.minExtractionTime == recipe.maxExtractionTime)
        #expect(recipe.minAmountBeans == recipe.maxAmountBeans)
        #expect(recipe.minOutput == recipe.maxOutput)
    }

    @Test func updateRecipeReturnsSameRecipe() throws {
        let (repository, context) = try prepareEnvironment()
        let useCase = UpdateRecipe(repository: repository)
        let recipe = makeWideRecipe(into: context)
        let request = UpdateRecipeRequest(
            name: "Espresso",
            brewer: nil,
            grinder: nil,
            temperature: 93,
            grindSetting: 9.0,
            extractionTime: 30,
            amountBeans: 18.0,
            output: 33.0
        )

        let result = try useCase(recipe: recipe, request: request)

        #expect(result.persistentModelID == recipe.persistentModelID)
    }

    // MARK: - DeleteRecipe

    @Test func deleteRecipeRemovesFromStore() throws {
        let (repository, context) = try prepareEnvironment()
        let useCase = DeleteRecipe(repository: repository)
        let recipe = makeWideRecipe(into: context)
        try context.save()

        try useCase(recipe: recipe)

        let remaining = try context.fetch(FetchDescriptor<Recipe>())
        #expect(remaining.isEmpty)
    }

    // MARK: - CalibrateRecipe

    @Test func calibrateRecipeLockAllRanges() throws {
        let (repository, context) = try prepareEnvironment()
        let useCase = CalibrateRecipe(repository: repository)
        let recipe = makeWideRecipe(into: context)
        let request = CalibrateRecipeRequest(
            recipe: recipe,
            temperature: 93,
            grindSetting: 9.0,
            extractionTime: 30,
            amountBeans: 18.0,
            output: 33.0
        )

        try useCase(request: request)

        #expect(recipe.minTemperature == 93)
        #expect(recipe.maxTemperature == 93)
        #expect(recipe.minGrindSetting == 9.0)
        #expect(recipe.maxGrindSetting == 9.0)
        #expect(recipe.minExtractionTime == 30)
        #expect(recipe.maxExtractionTime == 30)
        #expect(recipe.minAmountBeans == 18.0)
        #expect(recipe.maxAmountBeans == 18.0)
        #expect(recipe.minOutput == 33.0)
        #expect(recipe.maxOutput == 33.0)
    }

    @Test func calibrateRecipeCollapsesPreviouslyWideRanges() throws {
        let (repository, context) = try prepareEnvironment()
        let useCase = CalibrateRecipe(repository: repository)
        let recipe = makeWideRecipe(into: context)  // min/max are far apart
        let request = CalibrateRecipeRequest(
            recipe: recipe,
            temperature: 93,
            grindSetting: 9.0,
            extractionTime: 30,
            amountBeans: 18.0,
            output: 33.0
        )

        try useCase(request: request)

        #expect(recipe.minTemperature == recipe.maxTemperature)
        #expect(recipe.minGrindSetting == recipe.maxGrindSetting)
        #expect(recipe.minExtractionTime == recipe.maxExtractionTime)
        #expect(recipe.minAmountBeans == recipe.maxAmountBeans)
        #expect(recipe.minOutput == recipe.maxOutput)
    }

    @Test func calibrateRecipeReturnsSameRecipe() throws {
        let (repository, context) = try prepareEnvironment()
        let useCase = CalibrateRecipe(repository: repository)
        let recipe = makeWideRecipe(into: context)
        let request = CalibrateRecipeRequest(
            recipe: recipe,
            temperature: 93,
            grindSetting: 9.0,
            extractionTime: 30,
            amountBeans: 18.0,
            output: 33.0
        )

        let result = try useCase(request: request)

        #expect(result.persistentModelID == recipe.persistentModelID)
    }
}
