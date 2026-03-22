//
//  ResetUsesSinceMaintenance.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 21.03.26.
//

@MainActor struct PerformMaintenance {
    let repository: EquipmentRepository

    @discardableResult
    func callAsFunction(equipment: Equipment) throws -> Equipment {
        equipment.maintenanceCounter = (equipment.maintenanceCounter ?? 0) + 1
        equipment.usesSinceLastMaintenance = 0
        
        return try repository.update(equipment)
    }
}
