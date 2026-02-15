//
//  UseCases.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 25.10.25.
//

import Foundation
import SwiftUI
import SwiftData




struct UseCases {
    var createCoffee: @MainActor (CreateCoffeeRequest) throws -> Coffee
    var updateCoffee: @MainActor (Coffee) throws -> Coffee
    var checkCoffeeExists: @MainActor (String, String, Coffee?) throws -> Bool
    var brewDrink: @MainActor (Coffee, Brew, Recipe) throws -> Coffee
    var refillBeans: @MainActor (Coffee, Refill, Bool) throws -> Coffee
    var createEquipement: @MainActor (CreateEquipmentRequest) throws -> Equipment
    var createRecipe: @MainActor (CreateRecipeRequest) throws -> Recipe
    var updateRecipe: @MainActor (Recipe) throws -> Recipe
    var recalibrateRecipe: @MainActor (Recipe) throws -> Recipe
    var calibrateRecipe: @MainActor (CalibrateRecipeRequest) throws -> Recipe
}

enum UseCaseFactory {
    
    @MainActor
    static func make(context: ModelContext) -> UseCases {
        let coffeeRepository = SwiftDataCoffeeRepository(context: context)
        let equipmentRepository = SwiftDataEquipmentRepository(context: context)
        let recipeRepository = SwiftDataRecipeRepository(context: context)
        
        let createCoffee = CreateCoffee(repository: coffeeRepository).callAsFunction
        let updateCoffee = UpdateCoffee(repository: coffeeRepository).callAsFunction
        let checkCoffeeExists = CheckCoffeeExists(repository: coffeeRepository).callAsFunction
        let brewDrink = BrewDrink(repository: coffeeRepository).callAsFunction
        let refillBeans = RefillBeans(repository: coffeeRepository).callAsFunction
        let createEquipment = CreateEquipment(repository: equipmentRepository).callAsFunction
        let createRecipe = CreateRecipe(repository: recipeRepository).callAsFunction
        let updateRecipe = UpdateRecipe(repository: recipeRepository).callAsFunction
        let recalibrateRecipe = RecalibrateRecipe(repository: recipeRepository).callAsFunction
        let calibrateRecipe = CalibrateRecipe(repository: recipeRepository).callAsFunction
        
        return UseCases(
            createCoffee: createCoffee,
            updateCoffee: updateCoffee,
            checkCoffeeExists: checkCoffeeExists,
            brewDrink: brewDrink,
            refillBeans: refillBeans,
            createEquipement: createEquipment,
            createRecipe: createRecipe,
            updateRecipe: updateRecipe,
            recalibrateRecipe: recalibrateRecipe,
            calibrateRecipe: calibrateRecipe
        )
    }
}


extension EnvironmentValues {
    @Entry var useCases: UseCases = {
        return UseCases(
            createCoffee: { _ in
                fatalError("UseCases not injected")
            },
            updateCoffee: { _ in
                fatalError("UseCases not injected")
            },
            checkCoffeeExists: { _, _, _ in
                fatalError("UseCases not injected")
            },
            brewDrink:  { _, _, _ in
                fatalError("UseCases not injected")
            },
            refillBeans: { _, _, _
                in fatalError("UseCases not injected")
            },
            createEquipement: { _ in
                fatalError("UseCases not injected")
            },
            createRecipe: { _ in
                fatalError("UseCases not injected")
            },
            updateRecipe: { _ in
                fatalError("UseCases not injected")
            },
            recalibrateRecipe: { _ in
                fatalError("UseCases not injected")
            },
            calibrateRecipe: { _ in
                fatalError("UsesCases not injected")
            }
        )
    }()
}
