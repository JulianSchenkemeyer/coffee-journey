//
//  EquipmentUseCasesTests.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 11.03.26.
//
import Foundation
import Testing
import SwiftData
@testable import coffee_journey


@MainActor
struct EquipmentUseCasesTests {

    // MARK: - Helpers

    private func prepareEnvironment() throws -> (SwiftDataEquipmentRepository, ModelContext) {
        let container = ContainerFactory.createInMemory()
        let context = ModelContext(container)
        let repository = SwiftDataEquipmentRepository(context: context)
        return (repository, context)
    }

    private func makeEquipment(into context: ModelContext) -> Equipment {
        let equipment = Equipment(
            name: "Niche Zero",
            brand: "Niche",
            type: EquipmentType.grinder.rawValue,
            notes: ""
        )
        context.insert(equipment)
        return equipment
    }

    private func makeCreateRequest() -> CreateEquipmentRequest {
        CreateEquipmentRequest(
            name: "Picopresso",
            brand: "Wacaco",
            type: .machine,
            notes: "Travel-sized"
        )
    }

    // MARK: - CreateEquipment

    @Test func createEquipmentPersistsEquipment() throws {
        let (repository, context) = try prepareEnvironment()
        let useCase = CreateEquipment(repository: repository)

        try useCase(request: makeCreateRequest())

        let all = try context.fetch(FetchDescriptor<Equipment>())
        #expect(all.count == 1)
    }

    @Test func createEquipmentMapsRequestFields() throws {
        let (repository, _) = try prepareEnvironment()
        let useCase = CreateEquipment(repository: repository)

        let created = try useCase(request: makeCreateRequest())

        #expect(created.name == "Picopresso")
        #expect(created.brand == "Wacaco")
        #expect(created.type == .machine)
        #expect(created.notes == "Travel-sized")
    }

    @Test func createEquipmentReturnsCreatedEquipment() throws {
        let (repository, _) = try prepareEnvironment()
        let useCase = CreateEquipment(repository: repository)

        let created = try useCase(request: makeCreateRequest())

        #expect(created.name == "Picopresso")
    }

    // MARK: - UpdateEquipment

    @Test func updateEquipmentAppliesRequestFields() throws {
        let (repository, context) = try prepareEnvironment()
        let useCase = UpdateEquipment(repository: repository)
        let equipment = makeEquipment(into: context)
        let request = UpdateEquipmentRequest(
            name: "Niche Duo",
            brand: "Niche Coffee",
            type: .grinder,
            notes: "Upgraded model"
        )

        try useCase(equipment: equipment, request: request)

        #expect(equipment.name == "Niche Duo")
        #expect(equipment.brand == "Niche Coffee")
        #expect(equipment.type == .grinder)
        #expect(equipment.notes == "Upgraded model")
    }

    @Test func updateEquipmentReturnsSameEquipment() throws {
        let (repository, context) = try prepareEnvironment()
        let useCase = UpdateEquipment(repository: repository)
        let equipment = makeEquipment(into: context)
        let request = UpdateEquipmentRequest(
            name: "Updated",
            brand: "Updated",
            type: .kettle,
            notes: ""
        )

        let result = try useCase(equipment: equipment, request: request)

        #expect(result.persistentModelID == equipment.persistentModelID)
    }

    // MARK: - DeleteEquipment

    @Test func deleteEquipmentRemovesFromStore() throws {
        let (repository, context) = try prepareEnvironment()
        let useCase = DeleteEquipment(repository: repository)
        let equipment = makeEquipment(into: context)
        try context.save()

        try useCase(equipment: equipment)

        let remaining = try context.fetch(FetchDescriptor<Equipment>())
        #expect(remaining.isEmpty)
    }
    
    // MARK: - PerformMaintenance
    
    @Test func performMaintenanceIncrementsMaintenanceCounter() throws {
        let (repository, context) = try prepareEnvironment()
        let useCase = PerformMaintenance(repository: repository)
        let equipment = makeEquipment(into: context)
        
        equipment.totalUses = 3
        equipment.usesSinceLastMaintenance = 3
        _ = try context.save()
        
        try useCase(equipment: equipment, completedSteps: [], uncompletedSteps: [])
        
        #expect(equipment.maintenanceCounter == 1)
        
        try useCase(equipment: equipment, completedSteps: [], uncompletedSteps: [])
        
        #expect(equipment.maintenanceCounter == 2)
    }
    
    @Test func performMaintenanceDoesNotChangeTotalUses() throws {
        let (repository, context) = try prepareEnvironment()
        let useCase = PerformMaintenance(repository: repository)
        let equipment = makeEquipment(into: context)
        
        equipment.totalUses = 3
        equipment.usesSinceLastMaintenance = 3
        _ = try context.save()
        
        try useCase(equipment: equipment, completedSteps: [], uncompletedSteps: [])
        
        #expect(equipment.totalUses == 3)
    }
    
    @Test func performMaintenanceResets() throws {
        let (repository, context) = try prepareEnvironment()
        let useCase = PerformMaintenance(repository: repository)
        let equipment = makeEquipment(into: context)
        
        equipment.totalUses = 3
        equipment.usesSinceLastMaintenance = 3
        _ = try context.save()
        
        try useCase(equipment: equipment, completedSteps: [], uncompletedSteps: [])
        
        #expect(equipment.usesSinceLastMaintenance == 0)
    }
    
    @Test func performMaintenanceUpdatesLastMaintenanceDate() throws {
        let (repository, context) = try prepareEnvironment()
        let useCase = PerformMaintenance(repository: repository)
        let equipment = makeEquipment(into: context)
        
        equipment.totalUses = 3
        equipment.usesSinceLastMaintenance = 3
        _ = try context.save()
        
        let before = Date.now
        try useCase(equipment: equipment, completedSteps: [], uncompletedSteps: [])
        let after = Date.now
        
        let lastMaintenance = try #require(equipment.lastMaintenance)
        #expect(lastMaintenance >= before)
        #expect(lastMaintenance <= after)
    }
}
