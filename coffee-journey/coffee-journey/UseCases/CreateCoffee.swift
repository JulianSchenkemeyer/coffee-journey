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
        let defaultRecipe = Recipe(name: "Espresso", temperature: 96.0, grindsize: 12.0, extractionTime: 30, input: 18.0, output: 36.0)
        
        let newCoffee = Coffee(
            name: request.name,
            roaster: request.roaster,
            roastCategory: request.roastCategory.rawValue,
            amount: request.amount,
            amountLeft: request.amount,
            lastRefill: .now,
            brews: [],
            recipes: [defaultRecipe],
            totalBrews: 0,
            brewsSinceRefill: 0,
            roastDate: request.roastDate,
            rating: request.rating,
            notes: request.notes
        )
        
        defaultRecipe.coffee = newCoffee
        return try repository.create(newCoffee)
    }
}
