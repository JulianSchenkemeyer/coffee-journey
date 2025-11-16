//
//  UseCases.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 25.10.25.
//

import Foundation
import SwiftUI



struct UseCases {
    var createCoffee: @MainActor (CreateCoffeeRequest) throws -> Coffee
    var createEquipement: @MainActor (CreateEquipmentRequest) throws -> Equipment
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
