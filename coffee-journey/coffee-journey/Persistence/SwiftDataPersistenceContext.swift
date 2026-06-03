//
//  SwiftDataPersistenceContext.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 31.05.26.
//

import Foundation
import SwiftData


// Shared persistence context used by all SwiftData repositories.
// Stateless wrapper around ModelContext; the in-transaction signal lives in
// TransactionScope (see SwiftDataPersistenceTransaction.swift) as a task-local.
@MainActor
final class SwiftDataPersistenceContext {
    let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    // Called by repositories after staging changes. Saves immediately when
    // not in a transaction; no-ops when one is active (the transaction commits).
    // Callers wrap with their own typed PersistenceError when they want to
    // attach domain semantics to a save failure.
    func commitOrDefer() throws {
        guard !TransactionScope.isActive else { return }
        do {
            try modelContext.save()
        } catch {
            modelContext.rollback()
            throw error
        }
    }
}
