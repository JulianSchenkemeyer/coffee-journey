//
//  RecordBrew.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 03.05.26.
//

import Foundation

@MainActor struct RecordBrew {
    let coffeeRepository: CoffeeRepository

    @discardableResult
    func callAsFunction(brew: Brew, coffee: Coffee) throws -> Coffee {
        coffee.totalBrews += 1
        coffee.brewsSinceRefill += 1
        coffee.amountLeft = max(0, coffee.amountLeft - brew.amountCoffee)
        coffee.brews.append(brew)

        return try coffeeRepository.update(coffee)
    }
}
