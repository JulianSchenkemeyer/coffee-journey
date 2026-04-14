//
//  DeleteMaintenanceTemplate.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 13.04.26.
//

import Foundation


@MainActor struct DeleteMaintenanceTemplate {
    let repository: EquipmentRepository

    @discardableResult
    func callAsFunction(equipment: Equipment) throws -> Equipment {
        equipment.maintenanceTemplate = nil
        return try repository.update(equipment)
    }
}
