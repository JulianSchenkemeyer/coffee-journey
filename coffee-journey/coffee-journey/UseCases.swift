//
//  UseCases.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 25.10.25.
//

import Foundation
import SwiftUI

enum CoffeeCreationError: Error {
    case emptyName
    case invalidRating
}

enum RoastCategory: String, Codable, CaseIterable {
    case light, medium, dark
}

struct CreateCoffeeRequest {
    let name: String
    let roaster: String
    let roastCategory: RoastCategory
    let roastDate: Date
    let rating: Double
    let notes: String
}

struct UseCases {
    var createCoffee: @MainActor (CreateCoffeeRequest) throws -> Coffee
}


private struct UseCasesKey: EnvironmentKey {
    
    static let defaultValue = UseCases(
        createCoffee: {
            creationRequest in fatalError("UseCases not injected")
        }
    )
}

extension EnvironmentValues {
    var useCases: UseCases {
        get { self[UseCasesKey.self] }
        set { self[UseCasesKey.self] = newValue }
    }
}
