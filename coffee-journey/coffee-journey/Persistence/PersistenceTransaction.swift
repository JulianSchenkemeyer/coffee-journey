//
//  PersistenceTransaction.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 30.05.26.
//

import Foundation
import SwiftData


@MainActor
protocol PersistenceTransaction {
    func perform<T>(_ block: @MainActor () throws -> T) throws -> T
}


// Task-local flag indicating that a transaction is currently active on this task.
// Set only by SwiftDataPersistenceTransaction.perform via withValue, so the scope
// is torn down on every exit path (return, throw, cancellation).
// Note: not inherited by detached tasks — work spawned inside a transaction via
// Task.detached will not see isActive and will save eagerly.
enum TransactionScope {
    @TaskLocal static var isActive: Bool = false
}


@MainActor
struct SwiftDataPersistenceTransaction: PersistenceTransaction {
    let persistenceContext: SwiftDataPersistenceContext

    func perform<T>(_ block: @MainActor () throws -> T) throws -> T {
        // Re-entrant: nested perform calls run inside the outer transaction.
        if TransactionScope.isActive {
            return try block()
        }

        return try TransactionScope.$isActive.withValue(true) {
            let result: T
            do {
                result = try block()
            } catch {
                persistenceContext.modelContext.rollback()
                throw error
            }

            do {
                try persistenceContext.modelContext.save()
            } catch {
                persistenceContext.modelContext.rollback()
                throw PersistenceError.updateFailed
            }

            return result
        }
    }
}
