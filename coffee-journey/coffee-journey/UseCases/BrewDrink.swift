//
//  Brew.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 20.11.25.
//
import Foundation

@MainActor struct BrewDrink {
    let repository: CoffeeRepository
    
    @discardableResult
    func callAsFunction(coffee: Coffee, recipe: Recipe) throws -> Coffee {
        coffee.totalBrews += 1
        coffee.brewsSinceRefill += 1
        coffee.amountLeft = max(0, coffee.amountLeft - recipe.amountCoffee)
        
        return try repository.update(coffee)
    }
}
