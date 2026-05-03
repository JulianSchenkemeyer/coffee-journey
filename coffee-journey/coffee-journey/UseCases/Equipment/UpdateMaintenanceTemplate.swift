//
//  UpdateMaintenanceTemplate.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 13.04.26.
//

import Foundation
import SwiftData


@MainActor struct UpdateMaintenanceTemplate {
    let repository: EquipmentRepository

    @discardableResult
    func callAsFunction(
        template: MaintenanceTemplate,
        request: UpdateMaintenanceTemplateRequest
    ) throws -> MaintenanceTemplate {
        guard let equipment = template.equipment else {
            throw PersistenceError.updateFailed
        }
        
        let existingByID = Dictionary(
            uniqueKeysWithValues: template.steps.map { ($0.id, $0) }
        )
        let requestedIDs = Set(request.steps.compactMap(\.id))

        let toDelete = template.steps.filter { !requestedIDs.contains($0.id) }
        for step in toDelete {
            repository.remove(step)
        }

        for data in request.steps {
            if let id = data.id, let existing = existingByID[id] {
                existing.title = data.title
                existing.notes = data.notes
                existing.sortOrder = data.sortOrder
            } else {
                let step = MaintenanceTemplateStep(
                    title: data.title,
                    notes: data.notes,
                    sortOrder: data.sortOrder
                )
                repository.insert(step)
                template.steps.append(step)
            }
        }

        _ = try repository.update(equipment)

        return template
    }
}
