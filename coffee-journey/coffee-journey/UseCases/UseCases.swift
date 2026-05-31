//
//  UseCases.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 25.10.25.
//

import Foundation
import SwiftUI
import SwiftData


/// Factory for creating all domain-specific use case containers
enum UseCaseFactory {
    
    @MainActor
    static func makeAll(context: ModelContext) -> (
        coffee: CoffeeUseCases,
        recipe: RecipeUseCases,
        equipment: EquipmentUseCases,
        brew: BrewUseCases
    ) {
        let persistenceContext = SwiftDataPersistenceContext(modelContext: context)
        
        let coffeeRepository = SwiftDataCoffeeRepository(persistenceContext: persistenceContext)
        let equipmentRepository = SwiftDataEquipmentRepository(persistenceContext: persistenceContext)
        let recipeRepository = SwiftDataRecipeRepository(persistenceContext: persistenceContext)
        let brewRepository = SwiftDataBrewRepository(persistenceContext: persistenceContext)
        
        let coffeeUseCases = CoffeeUseCaseFactory.make(repository: coffeeRepository)
        let recipeUseCases = RecipeUseCaseFactory.make(repository: recipeRepository)
        let equipmentUseCases = EquipmentUseCaseFactory.make(repository: equipmentRepository)
        let brewUseCases = BrewUseCaseFactory.make(
            brewRepository: brewRepository,
            coffeeRepository: coffeeRepository,
            recipeRepository: recipeRepository,
            equipmentRepository: equipmentRepository
        )
        
        return (
            coffee: coffeeUseCases,
            recipe: recipeUseCases,
            equipment: equipmentUseCases,
            brew: brewUseCases
        )
    }
}

