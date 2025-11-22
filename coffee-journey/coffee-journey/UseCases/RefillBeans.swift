//
//  RefillBeans.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 20.11.25.
//

import Foundation

@MainActor struct RefillBeans {
    let repository: CoffeeRepository
    
    @discardableResult
    func callAsFunction(coffee: Coffee, dumpRest: Bool = false) throws -> Coffee {
        coffee.amount = 250
        coffee.brewsSinceRefill = 0
        if dumpRest {
            coffee.amountLeft = 250
        } else {
            coffee.amountLeft += 250
        }
        
        return try repository.update(coffee)
    }
}
