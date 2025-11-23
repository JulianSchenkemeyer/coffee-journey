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
    var brewDrink: @MainActor (Coffee, Recipe) throws -> Coffee
    var refillBeans: @MainActor (Coffee, Bool) throws -> Coffee
    var createEquipement: @MainActor (CreateEquipmentRequest) throws -> Equipment
}

enum UseCaseFactory {
    
    @MainActor
    static func make(context: ModelContext) -> UseCases {
        let coffeeRepository = SwiftDataCoffeeRepository(context: context)
        let equipmentRepository = SwiftDataEquipmentRepository(context: context)
        
        let createCoffee = CreateCoffee(repository: coffeeRepository).callAsFunction
        let brewDrink = BrewDrink(repository: coffeeRepository).callAsFunction
        let refillBeans = RefillBeans(repository: coffeeRepository).callAsFunction
        let createEquipment = CreateEquipment(repository: equipmentRepository).callAsFunction
        
        return UseCases(
            createCoffee: createCoffee,
            brewDrink: brewDrink,
            refillBeans: refillBeans,
            createEquipement: createEquipment
        )
    }
}


extension EnvironmentValues {
    @Entry var useCases: UseCases = UseCases(
        createCoffee: { _ in
            fatalError("UseCases not injected")
        },
        brewDrink:  { _, _ in
            fatalError("UseCases not injected")
        },
        refillBeans: { _, _
            in fatalError("UseCases not injected")
        },
        createEquipement: { _ in
            fatalError("UseCases not injected")
        }
    )
}
