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

    private func prepareEnvironment() throws -> (SwiftDataEquipmentRepository, SwiftDataPersistenceTransaction, ModelContext) {
        let container = ContainerFactory.createInMemory()
        let context = ModelContext(container)
        let persistenceContext = SwiftDataPersistenceContext(modelContext: context)
        let transaction = SwiftDataPersistenceTransaction(persistenceContext: persistenceContext)
        let repository = SwiftDataEquipmentRepository(persistenceContext: persistenceContext)
        return (repository, transaction, context)
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
        let (repository, _, context) = try prepareEnvironment()
        let useCase = CreateEquipment(repository: repository)

        try useCase(request: makeCreateRequest())

        let all = try context.fetch(FetchDescriptor<Equipment>())
        #expect(all.count == 1)
    }

    @Test func createEquipmentMapsRequestFields() throws {
        let (repository, _, _) = try prepareEnvironment()
        let useCase = CreateEquipment(repository: repository)

        let created = try useCase(request: makeCreateRequest())

        #expect(created.name == "Picopresso")
        #expect(created.brand == "Wacaco")
        #expect(created.type == .machine)
        #expect(created.notes == "Travel-sized")
    }

    @Test func createEquipmentReturnsCreatedEquipment() throws {
        let (repository, _, _) = try prepareEnvironment()
        let useCase = CreateEquipment(repository: repository)

        let created = try useCase(request: makeCreateRequest())

        #expect(created.name == "Picopresso")
    }

    // MARK: - UpdateEquipment

    @Test func updateEquipmentAppliesRequestFields() throws {
        let (repository, _, context) = try prepareEnvironment()
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
        let (repository, _, context) = try prepareEnvironment()
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
        let (repository, _, context) = try prepareEnvironment()
        let useCase = DeleteEquipment(repository: repository)
        let equipment = makeEquipment(into: context)
        try context.save()

        try useCase(equipment: equipment)

        let remaining = try context.fetch(FetchDescriptor<Equipment>())
        #expect(remaining.isEmpty)
    }
    
    // MARK: - PerformMaintenance
    
    @Test func performMaintenanceIncrementsMaintenanceCounter() async throws {
        let (repository, transaction, context) = try prepareEnvironment()
        let useCase = PerformMaintenance(repository: repository, transaction: transaction)
        let equipment = makeEquipment(into: context)

        equipment.totalUses = 3
        equipment.usesSinceLastMaintenance = 3
        _ = try context.save()

        try await useCase(equipment: equipment, completedSteps: [], uncompletedSteps: [])

        #expect(equipment.maintenanceCounter == 1)

        try await useCase(equipment: equipment, completedSteps: [], uncompletedSteps: [])

        #expect(equipment.maintenanceCounter == 2)
    }

    @Test func performMaintenanceDoesNotChangeTotalUses() async throws {
        let (repository, transaction, context) = try prepareEnvironment()
        let useCase = PerformMaintenance(repository: repository, transaction: transaction)
        let equipment = makeEquipment(into: context)

        equipment.totalUses = 3
        equipment.usesSinceLastMaintenance = 3
        _ = try context.save()

        try await useCase(equipment: equipment, completedSteps: [], uncompletedSteps: [])

        #expect(equipment.totalUses == 3)
    }

    @Test func performMaintenanceResets() async throws {
        let (repository, transaction, context) = try prepareEnvironment()
        let useCase = PerformMaintenance(repository: repository, transaction: transaction)
        let equipment = makeEquipment(into: context)

        equipment.totalUses = 3
        equipment.usesSinceLastMaintenance = 3
        _ = try context.save()

        try await useCase(equipment: equipment, completedSteps: [], uncompletedSteps: [])

        #expect(equipment.usesSinceLastMaintenance == 0)
    }

    // MARK: - PerformMaintenance atomicity

    private struct MaintenanceTestError: Error {}

    @Test func performMaintenanceRollsBackStagedInstanceOnOuterThrow() async throws {
        let (repository, transaction, context) = try prepareEnvironment()
        let useCase = PerformMaintenance(repository: repository, transaction: transaction)
        let equipment = makeEquipment(into: context)
        let template = MaintenanceTemplate(title: "Test", equipment: equipment, steps: [])
        equipment.maintenanceTemplate = template
        try context.save()

        await #expect(throws: MaintenanceTestError.self) {
            try await transaction.perform {
                _ = try await useCase(equipment: equipment, completedSteps: ["step"], uncompletedSteps: [])
                throw MaintenanceTestError()
            }
        }

        // Persisted state is what matters for atomicity. SwiftData's rollback reverts the
        // store, but in-memory model property mutations may linger on the local reference —
        // that's a SwiftData quirk, not an atomicity bug. The committed store is correct.
        let instances = try context.fetch(FetchDescriptor<MaintenanceInstance>())
        #expect(instances.isEmpty, "staged MaintenanceInstance must be rolled back when the outer transaction throws")
    }

    // MARK: - UpdateMaintenanceTemplate atomicity

    @Test func updateMaintenanceTemplateRollsBackStagedStepsOnOuterThrow() async throws {
        let (repository, transaction, context) = try prepareEnvironment()
        let useCase = UpdateMaintenanceTemplate(repository: repository, transaction: transaction)
        let equipment = makeEquipment(into: context)
        let template = MaintenanceTemplate(title: "Test", equipment: equipment, steps: [])
        equipment.maintenanceTemplate = template
        try context.save()

        let request = UpdateMaintenanceTemplateRequest(steps: [
            MaintenanceStepData(id: nil, title: "Descale", notes: "", sortOrder: 0)
        ])

        await #expect(throws: MaintenanceTestError.self) {
            try await transaction.perform {
                _ = try await useCase(template: template, request: request)
                throw MaintenanceTestError()
            }
        }

        let steps = try context.fetch(FetchDescriptor<MaintenanceTemplateStep>())
        #expect(steps.isEmpty, "staged MaintenanceTemplateStep must be rolled back when the outer transaction throws")
    }

    @Test func performMaintenanceUpdatesLastMaintenanceDate() async throws {
        let (repository, transaction, context) = try prepareEnvironment()
        let useCase = PerformMaintenance(repository: repository, transaction: transaction)
        let equipment = makeEquipment(into: context)

        equipment.totalUses = 3
        equipment.usesSinceLastMaintenance = 3
        _ = try context.save()

        let before = Date.now
        try await useCase(equipment: equipment, completedSteps: [], uncompletedSteps: [])
        let after = Date.now

        let lastMaintenance = try #require(equipment.lastMaintenance)
        #expect(lastMaintenance >= before)
        #expect(lastMaintenance <= after)
    }
}
