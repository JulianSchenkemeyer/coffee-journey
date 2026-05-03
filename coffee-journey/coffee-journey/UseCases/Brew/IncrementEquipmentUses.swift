//
//  IncrementEquipmentUses.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 03.05.26.
//

import Foundation

@MainActor struct IncrementEquipmentUses {
    let equipmentRepository: EquipmentRepository

    @discardableResult
    func callAsFunction(equipment: Equipment) throws -> Equipment {
        equipment.totalUses = (equipment.totalUses ?? 0) + 1
        equipment.usesSinceLastMaintenance = (equipment.usesSinceLastMaintenance ?? 0) + 1

        return try equipmentRepository.update(equipment)
    }
}
