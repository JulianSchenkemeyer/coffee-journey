//
//  UpdateCoffee.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 15.02.26.
//

@MainActor struct UpdateCoffee {
    let repository: CoffeeRepository

    @discardableResult
    func callAsFunction(coffee: Coffee, request: UpdateCoffeeRequest) throws -> Coffee {
        coffee.name = request.name
        coffee.roaster = request.roaster
        coffee.roastCategory = request.roastCategory.rawValue
        coffee.rating = request.rating
        coffee.notes = request.notes
        return try repository.update(coffee)
    }
}
