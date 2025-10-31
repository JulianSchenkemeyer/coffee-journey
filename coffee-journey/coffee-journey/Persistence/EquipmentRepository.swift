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
    func fetchAll() throws -> [Equipment]
    func findById(_ id: PersistentIdentifier) throws -> Equipment?
}

@MainActor
final class SwiftDataEquipmentRepository: EquipmentRepository {
    private let context: ModelContext
    init(context: ModelContext) { self.context = context }
    
    func create(_ equipment: Equipment) throws -> Equipment {
        context.insert(equipment)
        try context.save()
        
        return equipment
    }
    
    func update(_ equipment: Equipment) throws -> Equipment {
        try context.save()
        
        return equipment
    }
    
    func delete(_ equipment: Equipment) throws {
        context.delete(equipment)
        try context.save()
    }
    
    func fetchAll() throws -> [Equipment] {
        try context.fetch(FetchDescriptor<Equipment>())
    }
    
    func findById(_ id: PersistentIdentifier) throws -> Equipment? {
        let predicate = #Predicate<Equipment> {
            $0.id == id
        }
        let descriptor = FetchDescriptor<Equipment>(predicate: predicate)
        return try context.fetch(descriptor).first
    }
}

