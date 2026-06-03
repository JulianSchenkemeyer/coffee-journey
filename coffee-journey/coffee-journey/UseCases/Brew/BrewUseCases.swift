//
//  BrewUseCases.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 18.02.26.
//

import Foundation
import SwiftUI


struct BrewUseCases {
    var update: @MainActor (Brew) throws -> Brew
    var delete: @MainActor (Brew) throws -> Void
    var brew: @MainActor (Coffee, Brew, Recipe) async throws -> Coffee
}

enum BrewUseCaseFactory {
    
    @MainActor
    static func make(
        brewRepository: any BrewRepository,
        coffeeRepository: any CoffeeRepository,
        recipeRepository: any RecipeRepository,
        equipmentRepository: any EquipmentRepository,
        transaction: any PersistenceTransaction
    ) -> BrewUseCases {
        let recordBrew = RecordBrew(coffeeRepository: coffeeRepository)
        let updateRecipeFromBrew = UpdateRecipeFromBrew(recipeRepository: recipeRepository)
        let incrementEquipmentUses = IncrementEquipmentUses(equipmentRepository: equipmentRepository)

        let update = UpdateBrew(repository: brewRepository).callAsFunction
        let delete = DeleteBrew(repository: brewRepository).callAsFunction
        let brew = BrewDrink(
            recordBrew: recordBrew,
            updateRecipeFromBrew: updateRecipeFromBrew,
            incrementEquipmentUses: incrementEquipmentUses,
            transaction: transaction
        ).callAsFunction
        
        return BrewUseCases(
            update: update,
            delete: delete,
            brew: brew
        )
    }
}

extension EnvironmentValues {
    @Entry var brewUseCases: BrewUseCases = {
        return BrewUseCases(
            update: { _ in
                fatalError("BrewUseCases not injected")
            },
            delete: { _ in
                fatalError("BrewUseCases not injected")
            },
            brew: { _, _, _ in
                fatalError("BrewUseCases not injected")
            }
        )
    }()
}
