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
        equipment: EquipmentUseCases
    ) {
        let coffeeRepository = SwiftDataCoffeeRepository(context: context)
        let equipmentRepository = SwiftDataEquipmentRepository(context: context)
        let recipeRepository = SwiftDataRecipeRepository(context: context)
        
        let coffeeUseCases = CoffeeUseCaseFactory.make(repository: coffeeRepository)
        let recipeUseCases = RecipeUseCaseFactory.make(repository: recipeRepository)
        let equipmentUseCases = EquipmentUseCaseFactory.make(repository: equipmentRepository)
        
        return (
            coffee: coffeeUseCases,
            recipe: recipeUseCases,
            equipment: equipmentUseCases
        )
    }
}

