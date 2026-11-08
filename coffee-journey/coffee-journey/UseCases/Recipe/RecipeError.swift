//
//  RecipeError.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 08.11.26.
//
import Foundation


enum RecipeError: PresentableError {

    case duplicateEquipmentPair

    nonisolated var content: (title: String, description: String) {
        switch self {
        case .duplicateEquipmentPair:
            return (title: "Recipe already exists", description: "This coffee already has a recipe for this brewer and grinder.")
        }
    }

    nonisolated var errorDescription: String? {
        content.description
    }
}
