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
    func callAsFunction(creationRequest: CreateEquipmentRequest) throws -> Equipment {
        let newEquipment = Equipment(
            name: creationRequest.name,
            brand: creationRequest.brand,
            type: creationRequest.type.rawValue,
            notes: creationRequest.notes
        )
        return try repository.create(newEquipment)
    }
}
