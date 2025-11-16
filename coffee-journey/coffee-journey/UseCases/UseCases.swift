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
    var createEquipement: @MainActor (CreateEquipmentRequest) throws -> Equipment
}

enum UseCaseFactory {
    
    @MainActor
    static func make(container: ModelContainer) -> UseCases {
        let context = ModelContext(container)
        let coffeeRepository = SwiftDataCoffeeRepository(context: context)
        let equipmentRepository = SwiftDataEquipmentRepository(context: context)
        
        let createCoffee = CreateCoffee(repository: coffeeRepository).callAsFunction
        let createEquipment = CreateEquipment(repository: equipmentRepository).callAsFunction
        
        return UseCases(createCoffee: createCoffee, createEquipement: createEquipment)
    }
}


extension EnvironmentValues {
    @Entry var useCases: UseCases = UseCases(
        createCoffee: {
            _ in fatalError("UseCases not injected")
        },
        createEquipement: {
            _ in fatalError("UseCases not injected")
        }
    )
}
