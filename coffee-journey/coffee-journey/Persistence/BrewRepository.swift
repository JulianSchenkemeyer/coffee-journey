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
    private let persistenceContext: SwiftDataPersistenceContext
    private var context: ModelContext { persistenceContext.modelContext }

    init(persistenceContext: SwiftDataPersistenceContext) {
        self.persistenceContext = persistenceContext
    }

    func update(_ brew: Brew) throws -> Brew {
        try persistenceContext.commitOrDefer(onFailure: .updateFailed)
        return brew
    }

    func delete(_ brew: Brew) throws {
        context.delete(brew)
        try persistenceContext.commitOrDefer(onFailure: .deleteFailed)
    }
}
