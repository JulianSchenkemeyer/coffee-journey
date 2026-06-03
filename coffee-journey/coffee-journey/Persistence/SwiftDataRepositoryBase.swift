//
//  SwiftDataRepositoryBase.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 31.05.26.
//

import Foundation
import SwiftData


// Generic base providing the four CRUD operations common to every SwiftData
// repository in the adapter. Concrete repositories inherit from this and add
// their domain-specific methods (`exists`, `findById`, non-saving inserts, etc.).
// Internal to the SwiftData adapter — the domain Repository protocols remain
// the portability boundary.
@MainActor
class SwiftDataRepositoryBase<Model: PersistentModel> {
    let persistenceContext: SwiftDataPersistenceContext
    var context: ModelContext { persistenceContext.modelContext }

    init(persistenceContext: SwiftDataPersistenceContext) {
        self.persistenceContext = persistenceContext
    }

    final func create(_ model: Model) throws -> Model {
        context.insert(model)
        do {
            try persistenceContext.commitOrDefer()
        } catch {
            throw PersistenceError.insertFailed
        }
        return model
    }

    final func update(_ model: Model) throws -> Model {
        do {
            try persistenceContext.commitOrDefer()
        } catch {
            throw PersistenceError.updateFailed
        }
        return model
    }

    final func delete(_ model: Model) throws {
        context.delete(model)
        do {
            try persistenceContext.commitOrDefer()
        } catch {
            throw PersistenceError.deleteFailed
        }
    }

    final func fetchAll() throws -> [Model] {
        do {
            return try context.fetch(FetchDescriptor<Model>())
        } catch {
            throw PersistenceError.fetchFailed
        }
    }
}
