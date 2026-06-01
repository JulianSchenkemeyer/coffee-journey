//
//  EquipmentRepository.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 31.10.25.
//

import Foundation
import SwiftData


// insert/remove are non-saving — flush via update(_:) or wrap in a PersistenceTransaction.
// create/delete are atomic outside transactions; inside a transaction they defer to the transaction's commit.
protocol EquipmentRepository {
    func create(_ equipment: Equipment) throws -> Equipment
    func update(_ equipment: Equipment) throws -> Equipment
    func delete(_ equipment: Equipment) throws
    func insert(_ instance: MaintenanceInstance)
    func insert(_ step: MaintenanceTemplateStep)
    func remove(_ step: MaintenanceTemplateStep)
    func fetchAll() throws -> [Equipment]
    func findById(_ id: PersistentIdentifier) throws -> Equipment?
}

@MainActor
final class SwiftDataEquipmentRepository: SwiftDataRepositoryBase<Equipment>, EquipmentRepository {
    func insert(_ instance: MaintenanceInstance) {
        context.insert(instance)
    }

    func insert(_ step: MaintenanceTemplateStep) {
        context.insert(step)
    }

    func remove(_ step: MaintenanceTemplateStep) {
        context.delete(step)
    }

    func findById(_ id: PersistentIdentifier) throws -> Equipment? {
        let predicate = #Predicate<Equipment> {
            $0.id == id
        }
        let descriptor = FetchDescriptor<Equipment>(predicate: predicate)

        do {
            return try context.fetch(descriptor).first
        } catch {
            throw PersistenceError.fetchFailed
        }
    }
}
