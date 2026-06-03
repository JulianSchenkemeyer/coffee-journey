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


// Brews are created via Coffee.brews.append, not via a standalone create call,
// so SwiftDataBrewRepository deliberately does not inherit from SwiftDataRepositoryBase
// (which would expose unused create/fetchAll methods).
@MainActor
final class SwiftDataBrewRepository: BrewRepository {
    private let persistenceContext: SwiftDataPersistenceContext
    private var context: ModelContext { persistenceContext.modelContext }

    init(persistenceContext: SwiftDataPersistenceContext) {
        self.persistenceContext = persistenceContext
    }

    func update(_ brew: Brew) throws -> Brew {
        do {
            try persistenceContext.commitOrDefer()
        } catch {
            throw PersistenceError.updateFailed
        }
        return brew
    }

    func delete(_ brew: Brew) throws {
        context.delete(brew)
        do {
            try persistenceContext.commitOrDefer()
        } catch {
            throw PersistenceError.deleteFailed
        }
    }
}
