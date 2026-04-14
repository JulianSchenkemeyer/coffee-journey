//
//  UpdateMaintenanceTemplate.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 13.04.26.
//

import Foundation


@MainActor struct UpdateMaintenanceTemplate {
    let repository: EquipmentRepository

    @discardableResult
    func callAsFunction(template: MaintenanceTemplate, request: UpdateMaintenanceTemplateRequest) throws -> MaintenanceTemplate {
        template.steps.removeAll()

        let newSteps = request.steps.map {
            MaintenanceTemplateStep(title: $0.title, notes: $0.notes, sortOrder: $0.sortOrder)
        }
        template.steps = newSteps

        guard let equipment = template.equipment else {
            return template
        }
        _ = try repository.update(equipment)
        
        return template
    }
}
