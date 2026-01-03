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
    func callAsFunction(coffee: Coffee, brew: Brew) throws -> Coffee {
        coffee.totalBrews += 1
        coffee.brewsSinceRefill += 1
        coffee.amountLeft = max(0, coffee.amountLeft - brew.amountCoffee)
        coffee.brews.append(brew)
        
        return try repository.update(coffee)
    }
}
