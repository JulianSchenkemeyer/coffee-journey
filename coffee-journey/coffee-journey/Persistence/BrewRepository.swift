//
//  BrewRepository.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 18.02.26.
//
import Foundation
import SwiftData


protocol BrewRepository {
    func update(_ brew: Brew) throws -> Brew
    func delete(_ brew: Brew) throws
}


@MainActor
final class SwiftDataBrewRepository: BrewRepository {
    private let context: ModelContext
    init(context: ModelContext) { self.context = context }
    
    func update(_ brew: Brew) throws -> Brew {
        do {
            try context.save()
            
            return brew
        } catch {
            context.rollback()
            throw PersistenceError.updateFailed
        }
    }
    
    func delete(_ brew: Brew) throws {
        context.delete(brew)
        
        do {
            try context.save()
        } catch {
            context.rollback()
            throw PersistenceError.deleteFailed
        }
    }
}
