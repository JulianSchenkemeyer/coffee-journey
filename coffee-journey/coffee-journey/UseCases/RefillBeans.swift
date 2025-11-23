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
    func callAsFunction(coffee: Coffee, refill: Refill, dumpRest: Bool = false) throws -> Coffee {
        coffee.amount = refill.amount
        coffee.roastDate = refill.roastDate
        
        coffee.brewsSinceRefill = 0
        if dumpRest {
            coffee.amountLeft = refill.amount
        } else {
            coffee.amountLeft += refill.amount
        }
        
        return try repository.update(coffee)
    }
}
