//
//  EquipmentRepository.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 11.03.26.
//
import Foundation
import Testing
import SwiftData
@testable import coffee_journey


@MainActor
struct SwiftDataEquipmentRepositoryTests {
    
    // MARK: - Helpers

    private func prepareEnvironment() throws -> (SwiftDataEquipmentRepository, ModelContext) {
        let container = ContainerFactory.createInMemory()
        let context = ModelContext(container)
        let persistenceContext = SwiftDataPersistenceContext(modelContext: context)
        let repository = SwiftDataEquipmentRepository(persistenceContext: persistenceContext)
        return (repository, context)
    }
    
    
    @discardableResult
    private func insertEquipment(name: String, type: EquipmentType, into context: ModelContext) throws -> Equipment {
        let equipment = Equipment(
            name: name,
            brand: "Generic Brand",
            type: type.rawValue,
            notes: ""
        )
        
        context.insert(equipment)
        try context.save()
        
        return equipment
    }
    
    // MARK: - Create
    
    @Test func createPersistsEquipment() throws {
        let (repository, context) = try prepareEnvironment()
        let equipment = Equipment(
            name: "Picopresso",
            brand: "Wacaco",
            type: EquipmentType.machine.rawValue,
            notes: "Travel-sized"
        )

        let created = try repository.create(equipment)

        let all = try context.fetch(FetchDescriptor<Equipment>())
        #expect(all.count == 1)
        #expect(created.name == "Picopresso")
        #expect(created.brand == "Wacaco")
        #expect(created.type == EquipmentType.machine)
        #expect(created.notes == "Travel-sized")
    }

    @Test func createReturnsTheSameCoffee() throws {
        let (repository, _) = try prepareEnvironment()
        let equipment = Equipment(
            name: "Picopresso",
            brand: "Wacaco",
            type: EquipmentType.machine.rawValue,
            notes: "Travel-sized"
        )

        let created = try repository.create(equipment)

        #expect(created.persistentModelID == equipment.persistentModelID)
    }
    
    // MARK: - FetchAll

    @Test func fetchAllReturnsAllEquipment() throws {
        let (repository, context) = try prepareEnvironment()
        try insertEquipment(name: "Niche Zero", type: .grinder, into: context)
        try insertEquipment(name: "Fellow Stagg", type: .kettle, into: context)

        let result = try repository.fetchAll()

        #expect(result.count == 2)
    }

    @Test func fetchAllReturnsEmptyWhenStoreIsEmpty() throws {
        let (repository, _) = try prepareEnvironment()

        let result = try repository.fetchAll()

        #expect(result.isEmpty)
    }

    // MARK: - Update
    
    @Test func updatePersistsChanges() throws {
        let (repository, context) = try prepareEnvironment()
        let equipment = try insertEquipment(name: "Niche Zero", type: .grinder, into: context)

        equipment.name = "Niche Duo"
        equipment.notes = "Upgraded"
        let updated = try repository.update(equipment)

        let fetched = context.model(for: equipment.persistentModelID) as? Equipment
        #expect(updated.name == "Niche Duo")
        #expect(fetched?.name == "Niche Duo")
        #expect(fetched?.notes == "Upgraded")
    }
    
    @Test func updateReturnsTheSameEquipment() throws {
        let (repository, context) = try prepareEnvironment()
        let equipment = try insertEquipment(name: "Niche Zero", type: .grinder, into: context)

        let result = try repository.update(equipment)

        #expect(result.persistentModelID == equipment.persistentModelID)
    }

    // MARK: - Delete

    @Test func deleteRemovesEquipmentFromStore() throws {
        let (repository, context) = try prepareEnvironment()
        let equipment = try insertEquipment(name: "Niche Zero", type: .grinder, into: context)

        try repository.delete(equipment)

        let remaining = try context.fetch(FetchDescriptor<Equipment>())
        #expect(remaining.isEmpty)
    }

    @Test func deletingNonExistentEquipmentDoesNotThrow() throws {
        let (repository, context) = try prepareEnvironment()
        let equipment = try insertEquipment(name: "Niche Zero", type: .grinder, into: context)
        context.delete(equipment)           // delete directly, without saving
        try context.save()

        #expect(throws: Never.self) {
            try repository.delete(equipment)
        }
    }

    // MARK: - FindById

    @Test func findByIdReturnsMatchingEquipment() throws {
        let (repository, context) = try prepareEnvironment()
        let equipment = try insertEquipment(name: "Niche Zero", type: .grinder, into: context)

        let found = try repository.findById(equipment.persistentModelID)

        #expect(found?.persistentModelID == equipment.persistentModelID)
        #expect(found?.name == "Niche Zero")
    }

    @Test func findByIdReturnsNilForUnknownId() throws {
        let (repository, context) = try prepareEnvironment()
        let equipment = try insertEquipment(name: "Niche Zero", type: .grinder, into: context)
        let id = equipment.persistentModelID
        try repository.delete(equipment)

        let found = try repository.findById(id)

        #expect(found == nil)
    }
}
