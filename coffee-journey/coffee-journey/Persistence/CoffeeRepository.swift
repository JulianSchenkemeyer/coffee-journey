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
            
            // Use case-sensitive predicate to narrow down results, then do case-insensitive comparison in-memory
            let predicate = #Predicate<Coffee> { coffee in
                coffee.name.contains(trimmedName) && coffee.roaster.contains(trimmedRoaster)
            }
            
            let descriptor = FetchDescriptor<Coffee>(predicate: predicate)
            let candidates = try context.fetch(descriptor)
            
            // Now do case-insensitive comparison on the smaller result set
            let lowercasedName = trimmedName.lowercased()
            let lowercasedRoaster = trimmedRoaster.lowercased()
            
            for coffee in candidates {
                // If we're excluding a coffee (edit mode), skip it
                if let excluding = excluding, coffee.persistentModelID == excluding.persistentModelID {
                    continue
                }
                
                let coffeeName = coffee.name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                let coffeeRoaster = coffee.roaster.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                
                if coffeeName == lowercasedName && coffeeRoaster == lowercasedRoaster {
                    return true
                }
            }
            
            return false
        } catch {
            throw PersistenceError.fetchFailed
        }
    }
}


