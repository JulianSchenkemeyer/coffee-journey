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
final class SwiftDataRecipeRepository: SwiftDataRepositoryBase<Recipe>, RecipeRepository {}
