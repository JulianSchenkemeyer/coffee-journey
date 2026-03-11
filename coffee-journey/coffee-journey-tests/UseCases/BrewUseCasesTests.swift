//
//  BrewUseCasesTests.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 11.03.26.
//
import Foundation
import Testing
import SwiftData
@testable import coffee_journey


@MainActor
struct BrewDrinkTests {

    // MARK: - Helpers

    private func prepareEnvironment() throws -> (BrewDrink, ModelContext) {
        let container = ContainerFactory.createInMemory()
        let context = ModelContext(container)
        let coffeeRepo = SwiftDataCoffeeRepository(context: context)
        let recipeRepo = SwiftDataRecipeRepository(context: context)
        let useCase = BrewDrink(coffeeRepository: coffeeRepo, recipeRepository: recipeRepo)
        return (useCase, context)
    }

    private func makeCoffee(amountLeft: Double = 250.0, into context: ModelContext) -> Coffee {
        let coffee = Coffee(
            name: "Ethiopia",
            roaster: "Blue Bottle",
            roastCategory: "Light",
            amount: amountLeft,
            amountLeft: amountLeft,
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

    private func makeRecipe(into context: ModelContext) -> Recipe {
        let recipe = Recipe(
            name: "Espresso",
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
        return recipe
    }

    private func makeBrew(amountCoffee: Double = 18.0, rating: BrewRating = .thumbsUp) -> Brew {
        Brew(
            date: .now,
            amountCoffee: amountCoffee,
            grindSetting: 9.0,
            temperature: 93,
            extractionTime: 30,
            taste: BrewTaste.balanced.rawValue,
            output: 33.0,
            rating: rating
        )
    }

    // MARK: - Coffee counters

    @Test func brewIncrementsTotalBrews() throws {
        let (useCase, context) = try prepareEnvironment()
        let coffee = makeCoffee(into: context)
        let recipe = makeRecipe(into: context)
        let brew = makeBrew()

        try useCase(coffee: coffee, brew: brew, recipe: recipe)

        #expect(coffee.totalBrews == 1)
        
        try useCase(coffee: coffee, brew: brew, recipe: recipe)

        #expect(coffee.totalBrews == 2)
    }

    @Test func brewIncrementBrewsSinceRefill() throws {
        let (useCase, context) = try prepareEnvironment()
        let coffee = makeCoffee(into: context)
        let recipe = makeRecipe(into: context)
        let brew = makeBrew()

        try useCase(coffee: coffee, brew: brew, recipe: recipe)

        #expect(coffee.brewsSinceRefill == 1)
    }

    @Test func brewDeductsAmountFromCoffee() throws {
        let (useCase, context) = try prepareEnvironment()
        let coffee = makeCoffee(amountLeft: 250.0, into: context)
        let recipe = makeRecipe(into: context)
        let brew = makeBrew(amountCoffee: 18.0)

        try useCase(coffee: coffee, brew: brew, recipe: recipe)

        #expect(coffee.amountLeft == 232.0)
    }

    @Test func brewDoesNotReduceAmountLeftBelowZero() throws {
        let (useCase, context) = try prepareEnvironment()
        let coffee = makeCoffee(amountLeft: 10.0, into: context)
        let recipe = makeRecipe(into: context)
        let brew = makeBrew(amountCoffee: 18.0)

        try useCase(coffee: coffee, brew: brew, recipe: recipe)

        #expect(coffee.amountLeft == 0.0)
    }

    @Test func brewAppendsToCoffeeBrewList() throws {
        let (useCase, context) = try prepareEnvironment()
        let coffee = makeCoffee(into: context)
        let recipe = makeRecipe(into: context)
        let brew = makeBrew()

        try useCase(coffee: coffee, brew: brew, recipe: recipe)

        #expect(coffee.brews.count == 1)
    }

    @Test func brewReturnsCoffee() throws {
        let (useCase, context) = try prepareEnvironment()
        let coffee = makeCoffee(into: context)
        let recipe = makeRecipe(into: context)
        let brew = makeBrew()

        let result = try useCase(coffee: coffee, brew: brew, recipe: recipe)

        #expect(result.persistentModelID == coffee.persistentModelID)
    }

    // MARK: - Recipe calibration (thumbsUp)

    @Test func thumbsUpUpdatesRecipeLastUsed() throws {
        let (useCase, context) = try prepareEnvironment()
        let coffee = makeCoffee(into: context)
        let recipe = makeRecipe(into: context)
        let brew = makeBrew(rating: .thumbsUp)

        try useCase(coffee: coffee, brew: brew, recipe: recipe)

        #expect(recipe.lastUsed != nil)
    }

    @Test func thumbsUpNarrowsRecipeRangeWhenBrewIsWithinBounds() throws {
        let (useCase, context) = try prepareEnvironment()
        let coffee = makeCoffee(into: context)
        // Recipe has a wide range; brew falls within it — ranges should not change
        let recipe = makeRecipe(into: context)   // beans: 17–19, grind: 8–10, temp: 90–96, time: 25–35, output: 30–36
        let brew = makeBrew(rating: .thumbsUp)   // beans: 18, grind: 9, temp: 93, time: 30, output: 33

        try useCase(coffee: coffee, brew: brew, recipe: recipe)

        #expect(recipe.minAmountBeans == 17.0)
        #expect(recipe.maxAmountBeans == 19.0)
        #expect(recipe.minGrindSetting == 8.0)
        #expect(recipe.maxGrindSetting == 10.0)
    }

    @Test func thumbsUpExpandsRecipeRangeWhenBrewIsOutsideBounds() throws {
        let (useCase, context) = try prepareEnvironment()
        let coffee = makeCoffee(into: context)
        // Recipe with exact single-value ranges
        let recipe = Recipe(
            name: "Espresso",
            temperature: 93,
            grindSetting: 9.0,
            extractionTime: 30,
            input: 18.0,
            output: 33.0
        )
        context.insert(recipe)
        // Brew with values outside the locked range
        let brew = Brew(
            date: .now,
            amountCoffee: 20.0,
            grindSetting: 11.0,
            temperature: 95,
            extractionTime: 35,
            taste: BrewTaste.balanced.rawValue,
            output: 38.0,
            rating: .thumbsUp
        )

        try useCase(coffee: coffee, brew: brew, recipe: recipe)

        #expect(recipe.maxAmountBeans == 20.0)
        #expect(recipe.maxGrindSetting == 11.0)
        #expect(recipe.maxTemperature == 95)
        #expect(recipe.maxExtractionTime == 35)
        #expect(recipe.maxOutput == 38.0)
    }

    // MARK: - Recipe calibration (thumbsDown)

    @Test func thumbsDownDoesNotUpdateRecipeLastUsed() throws {
        let (useCase, context) = try prepareEnvironment()
        let coffee = makeCoffee(into: context)
        let recipe = makeRecipe(into: context)
        let brew = makeBrew(rating: .thumbsDown)

        try useCase(coffee: coffee, brew: brew, recipe: recipe)

        #expect(recipe.lastUsed == nil)
    }

    @Test func thumbsDownDoesNotChangeRecipeRanges() throws {
        let (useCase, context) = try prepareEnvironment()
        let coffee = makeCoffee(into: context)
        let recipe = makeRecipe(into: context)
        let brew = Brew(
            date: .now,
            amountCoffee: 20.0,
            grindSetting: 11.0,
            temperature: 99,
            extractionTime: 40,
            taste: BrewTaste.bitter.rawValue,
            output: 40.0,
            rating: .thumbsDown
        )

        try useCase(coffee: coffee, brew: brew, recipe: recipe)

        #expect(recipe.minAmountBeans == 17.0)
        #expect(recipe.maxAmountBeans == 19.0)
        #expect(recipe.minGrindSetting == 8.0)
        #expect(recipe.maxGrindSetting == 10.0)
        #expect(recipe.minTemperature == 90)
        #expect(recipe.maxTemperature == 96)
        #expect(recipe.minExtractionTime == 25)
        #expect(recipe.maxExtractionTime == 35)
        #expect(recipe.minOutput == 30.0)
        #expect(recipe.maxOutput == 36.0)
    }

    @Test func thumbsDownStillAppendsBrew() throws {
        let (useCase, context) = try prepareEnvironment()
        let coffee = makeCoffee(into: context)
        let recipe = makeRecipe(into: context)
        let brew = makeBrew(rating: .thumbsDown)

        try useCase(coffee: coffee, brew: brew, recipe: recipe)

        #expect(coffee.brews.count == 1)
        #expect(coffee.totalBrews == 1)
    }
}
