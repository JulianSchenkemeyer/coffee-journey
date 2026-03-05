//
//  UpdateEquipment.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 05.03.26.
//

@MainActor struct UpdateEquipment {
    let repository: EquipmentRepository

    @discardableResult
    func callAsFunction(equipment: Equipment, request: UpdateEquipmentRequest) throws -> Equipment {
        equipment.name = request.name
        equipment.brand = request.brand
        equipment.typeDescription = request.type.rawValue
        equipment.notes = request.notes
        return try repository.update(equipment)
    }
}
