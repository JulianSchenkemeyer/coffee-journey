//
//  EquipmentUseCases.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 15.02.26.
//

import Foundation
import SwiftUI
import SwiftData


struct EquipmentUseCases {
    var create: @MainActor (CreateEquipmentRequest) throws -> Equipment
    var delete: @MainActor (Equipment) throws -> Void
}

enum EquipmentUseCaseFactory {
    
    @MainActor
    static func make(repository: any EquipmentRepository) -> EquipmentUseCases {
        let create = CreateEquipment(repository: repository).callAsFunction
        let delete = DeleteEquipment(repository: repository).callAsFunction
        
        return EquipmentUseCases(
            create: create,
            delete: delete
        )
    }
}

extension EnvironmentValues {
    @Entry var equipmentUseCases: EquipmentUseCases = {
        return EquipmentUseCases(
            create: { _ in
                fatalError("EquipmentUseCases not injected")
            },
            delete: { _ in
                fatalError("EquipmentUseCases not injected")
            }
        )
    }()
}
