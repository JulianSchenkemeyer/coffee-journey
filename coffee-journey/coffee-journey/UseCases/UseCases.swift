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


private struct UseCasesKey: EnvironmentKey {
    
    static let defaultValue = UseCases(
        createCoffee: {
            _ in fatalError("UseCases not injected")
        },
        createEquipement: {
            _ in fatalError("UseCases not injected")
        }
    )
}

extension EnvironmentValues {
    var useCases: UseCases {
        get { self[UseCasesKey.self] }
        set { self[UseCasesKey.self] = newValue }
    }
}
