//
//  CoffeeUseCases.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 15.02.26.
//

import Foundation
import SwiftUI
import SwiftData


struct CoffeeUseCases {
    var create: @MainActor (CreateCoffeeRequest) throws -> Coffee
    var update: @MainActor (Coffee) throws -> Coffee
    var delete: @MainActor (Coffee) throws -> Void
    var checkExists: @MainActor (String, String, Coffee?) throws -> Bool
    var brew: @MainActor (Coffee, Brew, Recipe) throws -> Coffee
    var refill: @MainActor (Coffee, Refill, Bool) throws -> Coffee
}

enum CoffeeUseCaseFactory {
    
    @MainActor
    static func make(repository: any CoffeeRepository) -> CoffeeUseCases {
        let create = CreateCoffee(repository: repository).callAsFunction
        let update = UpdateCoffee(repository: repository).callAsFunction
        let delete = DeleteCoffee(repository: repository).callAsFunction
        let checkExists = CheckCoffeeExists(repository: repository).callAsFunction
        let brew = BrewDrink(repository: repository).callAsFunction
        let refill = RefillBeans(repository: repository).callAsFunction
        
        return CoffeeUseCases(
            create: create,
            update: update,
            delete: delete,
            checkExists: checkExists,
            brew: brew,
            refill: refill
        )
    }
}

extension EnvironmentValues {
    @Entry var coffeeUseCases: CoffeeUseCases = {
        return CoffeeUseCases(
            create: { _ in
                fatalError("CoffeeUseCases not injected")
            },
            update: { _ in
                fatalError("CoffeeUseCases not injected")
            },
            delete: { _ in
                fatalError("CoffeeUseCases not injected")
            },
            checkExists: { _, _, _ in
                fatalError("CoffeeUseCases not injected")
            },
            brew: { _, _, _ in
                fatalError("CoffeeUseCases not injected")
            },
            refill: { _, _, _ in
                fatalError("CoffeeUseCases not injected")
            }
        )
    }()
}
