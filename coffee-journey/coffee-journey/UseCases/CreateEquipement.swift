//
//  CreateEquipement.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 31.10.25.
//

import Foundation

@MainActor struct CreateEquipment {
    let repository: EquipmentRepository
    
    @discardableResult
    func callAsFunction(request: CreateEquipmentRequest) throws -> Equipment {
        let newEquipment = Equipment(
            name: request.name,
            brand: request.brand,
            type: request.type.rawValue,
            notes: request.notes
        )
        return try repository.create(newEquipment)
    }
}
