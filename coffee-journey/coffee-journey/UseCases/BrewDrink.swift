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
    func callAsFunction(coffee: Coffee) throws -> Coffee {
        coffee.totalBrews += 1
        coffee.brewsSinceRefill += 1
        
        return try repository.update(coffee)
    }
}
