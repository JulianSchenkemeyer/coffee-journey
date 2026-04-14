//
//  CreateMaintenanceTemplate.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 13.04.26.
//

import Foundation


@MainActor struct CreateMaintenanceTemplate {
    let repository: EquipmentRepository

    @discardableResult
    func callAsFunction(equipment: Equipment) throws -> Equipment {
        let template = MaintenanceTemplate(
            title: equipment.name,
            equipment: equipment,
            steps: []
        )
        equipment.maintenanceTemplate = template
        return try repository.update(equipment)
    }
}
