//
//  CoffeeRepo.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 24.10.25.
//
import Foundation
import SwiftData

protocol CoffeeRepository {
    func create(_ coffee: Coffee) throws -> Coffee
    func fetchAll() throws -> [Coffee]
    func update(_ coffee: Coffee) throws -> Coffee
    func delete(_ coffee: Coffee) throws
    func exists(name: String, roaster: String, excluding: Coffee?) throws -> Bool
}

@MainActor
final class SwiftDataCoffeeRepository: CoffeeRepository {
    private let persistenceContext: SwiftDataPersistenceContext
    private var context: ModelContext { persistenceContext.modelContext }

    init(persistenceContext: SwiftDataPersistenceContext) {
        self.persistenceContext = persistenceContext
    }


    func create(_ coffee: Coffee) throws -> Coffee {
        context.insert(coffee)
        try persistenceContext.commitOrDefer(onFailure: .insertFailed)
        return coffee
    }

    func update(_ coffee: Coffee) throws -> Coffee {
        try persistenceContext.commitOrDefer(onFailure: .updateFailed)
        return coffee
    }

    func delete(_ coffee: Coffee) throws {
        context.delete(coffee)
        try persistenceContext.commitOrDefer(onFailure: .deleteFailed)
    }
    
    func fetchAll() throws -> [Coffee] {
        do {
            return try context.fetch(FetchDescriptor<Coffee>())
        } catch {
            throw PersistenceError.fetchFailed
        }
    }
    
    func exists(name: String, roaster: String, excluding: Coffee?) throws -> Bool {
        do {
            let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
            let trimmedRoaster = roaster.trimmingCharacters(in: .whitespacesAndNewlines)
            let orderedSame = ComparisonResult.orderedSame

            let predicate = #Predicate<Coffee> { coffee in
                coffee.name.caseInsensitiveCompare(trimmedName) == orderedSame &&
                coffee.roaster.caseInsensitiveCompare(trimmedRoaster) == orderedSame
            }

            let candidates = try context.fetch(FetchDescriptor<Coffee>(predicate: predicate))

            // Filter out the excluded coffee in-memory (edit mode),
            // since PersistentIdentifier cannot be used inside a #Predicate.
            return candidates.contains { coffee in
                guard let excluding else { return true }
                return coffee.persistentModelID != excluding.persistentModelID
            }
        } catch {
            throw PersistenceError.fetchFailed
        }
    }
}


