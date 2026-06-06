//
//  PerformMaintenance.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 21.03.26.
//
import Foundation


@MainActor struct PerformMaintenance {
    let repository: EquipmentRepository
    let transaction: any PersistenceTransaction

    @discardableResult
    func callAsFunction(
        equipment: Equipment,
        completedSteps: [String],
        uncompletedSteps: [String]
    ) async throws -> Equipment {
        try await transaction.perform {
            if let template = equipment.maintenanceTemplate {
                let instance = MaintenanceInstance(
                    template: template,
                    completedAt: .now,
                    completedSteps: completedSteps,
                    uncompletedSteps: uncompletedSteps
                )
                repository.insert(instance)
                template.instances.append(instance)
            }

            equipment.maintenanceCounter = (equipment.maintenanceCounter ?? 0) + 1
            equipment.usesSinceLastMaintenance = 0
            equipment.lastMaintenance = .now

            return try repository.update(equipment)
        }
    }
}
