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
    func callAsFunction(creationRequest: CreateCoffeeRequest) throws -> Coffee {
        let defaultRecipe = Recipe(name: "Espresso", temperature: 96.0, grindsize: 12.0, extractionTime: 30, input: 18.0, output: 36.0)
        
        let newCoffee = Coffee(
            name: creationRequest.name,
            roaster: creationRequest.roaster,
            roastCategory: creationRequest.roastCategory.rawValue,
            amount: creationRequest.amount,
            amountLeft: creationRequest.amount,
            lastRefill: .now,
            brews: [],
            recipes: [defaultRecipe],
            totalBrews: 0,
            brewsSinceRefill: 0,
            roastDate: creationRequest.roastDate,
            rating: creationRequest.rating,
            notes: creationRequest.notes
        )
        return try repository.create(newCoffee)
    }
}
