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
}

final class SwiftDataCoffeeRepository: CoffeeRepository {
    private let context: ModelContext
    init(context: ModelContext) { self.context = context }

    
    func create(_ coffee: Coffee) throws -> Coffee {
        context.insert(coffee)
        try context.save()
        
        return coffee
    }
    
    func fetchAll() throws -> [Coffee] {
        (try? context.fetch(FetchDescriptor<Coffee>())) ?? []
    }
    
    func update(_ coffee: Coffee) throws -> Coffee {
        try context.save()
        
        return coffee
    }
    
    func delete(_ coffee: Coffee) throws {
        
    }
    
    
}


