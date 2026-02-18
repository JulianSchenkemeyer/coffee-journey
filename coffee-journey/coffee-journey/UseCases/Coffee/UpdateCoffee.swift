//
//  UpdateCoffee.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 15.02.26.
//

@MainActor struct UpdateCoffee {
    let repository: CoffeeRepository
    
    
    @discardableResult
    func callAsFunction(coffee: Coffee) throws -> Coffee {
        return try repository.update(coffee)
    }
}
