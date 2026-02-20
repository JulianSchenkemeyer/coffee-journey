//
//  DeleteEquipment.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 19.02.26.
//

@MainActor struct DeleteEquipment {
    let repository: EquipmentRepository

    func callAsFunction(equipment: Equipment) throws {
        try repository.delete(equipment)
    }
}
