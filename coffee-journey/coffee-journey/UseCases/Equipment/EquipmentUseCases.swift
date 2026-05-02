//
//  EquipmentUseCases.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 15.02.26.
//

import Foundation
import SwiftUI
import SwiftData


struct EquipmentUseCases {
    var create: @MainActor (CreateEquipmentRequest) throws -> Equipment
    var update: @MainActor (Equipment, UpdateEquipmentRequest) throws -> Equipment
    var delete: @MainActor (Equipment) throws -> Void
    var performMaintenance: @MainActor (Equipment, [String], [String]) throws -> Equipment
    var createMaintenanceTemplate: @MainActor (Equipment) throws -> MaintenanceTemplate
    var updateMaintenanceTemplate: @MainActor (MaintenanceTemplate, UpdateMaintenanceTemplateRequest) throws -> MaintenanceTemplate
    var deleteMaintenanceTemplate: @MainActor (Equipment) throws -> Equipment
}

enum EquipmentUseCaseFactory {
    
    @MainActor
    static func make(repository: any EquipmentRepository) -> EquipmentUseCases {
        let create = CreateEquipment(repository: repository).callAsFunction
        let update = UpdateEquipment(repository: repository).callAsFunction
        let delete = DeleteEquipment(repository: repository).callAsFunction
        let performMaintenance = PerformMaintenance(repository: repository).callAsFunction
        let createMaintenanceTemplate = CreateMaintenanceTemplate(repository: repository).callAsFunction
        let updateMaintenanceTemplate = UpdateMaintenanceTemplate(repository: repository).callAsFunction
        let deleteMaintenanceTemplate = DeleteMaintenanceTemplate(repository: repository).callAsFunction

        return EquipmentUseCases(
            create: create,
            update: update,
            delete: delete,
            performMaintenance: performMaintenance,
            createMaintenanceTemplate: createMaintenanceTemplate,
            updateMaintenanceTemplate: updateMaintenanceTemplate,
            deleteMaintenanceTemplate: deleteMaintenanceTemplate
        )
    }
}

extension EnvironmentValues {
    @Entry var equipmentUseCases: EquipmentUseCases = {
        return EquipmentUseCases(
            create: { _ in
                fatalError("EquipmentUseCases not injected")
            },
            update: { _, _ in
                fatalError("EquipmentUseCases not injected")
            },
            delete: { _ in
                fatalError("EquipmentUseCases not injected")
            },
            performMaintenance: { _, _, _ in
                fatalError("EquipmentUseCases not injected")
            },
            createMaintenanceTemplate: { _ in
                fatalError("EquipmentUseCases not injected")
            },
            updateMaintenanceTemplate: { _, _ in
                fatalError("EquipmentUseCases not injected")
            },
            deleteMaintenanceTemplate: { _ in
                fatalError("EquipmentUseCases not injected")
            }
        )
    }()
}
