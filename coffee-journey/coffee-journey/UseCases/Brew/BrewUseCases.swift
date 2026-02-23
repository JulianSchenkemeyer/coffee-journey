//
//  BrewUseCases.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 18.02.26.
//

//
//  CoffeeUseCases.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 15.02.26.
//

import Foundation
import SwiftUI
import SwiftData


struct BrewUseCases {
    var update: @MainActor (Brew) throws -> Brew
    var delete: @MainActor (Brew) throws -> Void
    var brew: @MainActor (Coffee, Brew, Recipe) throws -> Coffee
}

enum BrewUseCaseFactory {
    
    @MainActor
    static func make(
        brewRepository: any BrewRepository,
        coffeeRepository: any CoffeeRepository,
        recipeRepository: any RecipeRepository
    ) -> BrewUseCases {
        let update = UpdateBrew(repository: brewRepository).callAsFunction
        let delete = DeleteBrew(repository: brewRepository).callAsFunction
        let brew = BrewDrink(coffeeRepository: coffeeRepository, recipeRepository: recipeRepository).callAsFunction
        
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
