//
//  EquipmentRepository.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 31.10.25.
//

import Foundation
import SwiftData


protocol EquipmentRepository {
    func create(_ equipment: Equipment) throws -> Equipment
    func update(_ equipment: Equipment) throws -> Equipment
    func delete(_ equipment: Equipment) throws
    func delete(_ step: MaintenanceTemplateStep) throws
    func insert(_ instance: MaintenanceInstance)
    func insert(_ step: MaintenanceTemplateStep)
    func fetchAll() throws -> [Equipment]
    func findById(_ id: PersistentIdentifier) throws -> Equipment?
}

@MainActor
final class SwiftDataEquipmentRepository: EquipmentRepository {
    private let context: ModelContext
    init(context: ModelContext) { self.context = context }
    
    func create(_ equipment: Equipment) throws -> Equipment {
        context.insert(equipment)
        
        do {
            try context.save()
            
            return equipment
        } catch {
            context.rollback()
            throw PersistenceError.insertFailed
        }
    }
    
    func update(_ equipment: Equipment) throws -> Equipment {
        do {
            try context.save()
            
            return equipment
        } catch {
            context.rollback()
            throw PersistenceError.updateFailed
        }
    }
    
    func delete(_ equipment: Equipment) throws {
        context.delete(equipment)

        do {
            try context.save()
        } catch {
            context.rollback()
            throw PersistenceError.deleteFailed
        }
    }

    func delete(_ step: MaintenanceTemplateStep) throws {
        context.delete(step)

        do {
            try context.save()
        } catch {
            context.rollback()
            throw PersistenceError.deleteFailed
        }
    }

    func insert(_ instance: MaintenanceInstance) {
        context.insert(instance)
    }

    func insert(_ step: MaintenanceTemplateStep) {
        context.insert(step)
    }

    func fetchAll() throws -> [Equipment] {
        do {
            return try context.fetch(FetchDescriptor<Equipment>())
        } catch {
            throw PersistenceError.fetchFailed
        }
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

