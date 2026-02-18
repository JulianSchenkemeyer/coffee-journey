//
//  DeleteCoffee.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 17.02.26.
//

@MainActor struct DeleteCoffee {
    let repository: CoffeeRepository
    
    
    func callAsFunction(coffee: Coffee) throws {
        try repository.delete(coffee)
    }
}
