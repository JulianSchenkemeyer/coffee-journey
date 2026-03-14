//
//  EmptyBeans.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 14.03.26.
//

import Foundation


@MainActor struct EmptyBeans {
    let repository: CoffeeRepository
    
    
    @discardableResult
    func callAsFunction(coffee: Coffee) throws -> Coffee {
        
        coffee.brewsSinceRefill = 0
        coffee.amountLeft = 0
        
        return try repository.update(coffee)
    }
}
