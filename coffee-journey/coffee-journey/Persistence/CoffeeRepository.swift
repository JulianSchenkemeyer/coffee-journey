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
    private let context: ModelContext
    init(context: ModelContext) { self.context = context }

    
    func create(_ coffee: Coffee) throws -> Coffee {
        context.insert(coffee)
        
        do {
            try context.save()
            
            return coffee
        } catch {
            context.rollback()
            throw PersistenceError.insertFailed
        }
    }
    
    func update(_ coffee: Coffee) throws -> Coffee {
        do {
            try context.save()
            
            return coffee
        } catch {
            context.rollback()
            throw PersistenceError.updateFailed
        }
    }
    
    func delete(_ coffee: Coffee) throws {
        context.delete(coffee)

        do {
            try context.save()
        } catch {
            context.rollback()
            throw PersistenceError.deleteFailed
        }
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


