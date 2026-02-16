//
//  RecipeUseCases.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 15.02.26.
//

import Foundation
import SwiftUI
import SwiftData


struct RecipeUseCases {
    var create: @MainActor (CreateRecipeRequest) throws -> Recipe
    var update: @MainActor (Recipe) throws -> Recipe
    var recalibrate: @MainActor (Recipe) throws -> Recipe
    var calibrate: @MainActor (CalibrateRecipeRequest) throws -> Recipe
}

enum RecipeUseCaseFactory {
    
    @MainActor
    static func make(repository: SwiftDataRecipeRepository) -> RecipeUseCases {
        let create = CreateRecipe(repository: repository).callAsFunction
        let update = UpdateRecipe(repository: repository).callAsFunction
        let recalibrate = RecalibrateRecipe(repository: repository).callAsFunction
        let calibrate = CalibrateRecipe(repository: repository).callAsFunction
        
        return RecipeUseCases(
            create: create,
            update: update,
            recalibrate: recalibrate,
            calibrate: calibrate
        )
    }
}

extension EnvironmentValues {
    @Entry var recipeUseCases: RecipeUseCases = {
        return RecipeUseCases(
            create: { _ in
                fatalError("RecipeUseCases not injected")
            },
            update: { _ in
                fatalError("RecipeUseCases not injected")
            },
            recalibrate: { _ in
                fatalError("RecipeUseCases not injected")
            },
            calibrate: { _ in
                fatalError("RecipeUseCases not injected")
            }
        )
    }()
}
