//
//  CreateCoffee.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 25.10.25.
//
import Foundation

@MainActor struct CreateCoffee {
    let repository: CoffeeRepository
    
    @discardableResult
    func callAsFunction(request: CreateCoffeeRequest) throws -> Coffee {
        let newCoffee = Coffee(
            name: request.name,
            roaster: request.roaster,
            roastCategory: request.roastCategory.rawValue,
            amount: request.amount,
            amountLeft: request.amount,
            lastRefill: .now,
            brews: [],
            recipes: [],
            totalBrews: 0,
            brewsSinceRefill: 0,
            roastDate: request.roastDate,
            rating: request.rating,
            notes: request.notes
        )
        
        return try repository.create(newCoffee)
    }
}
