//
//  CreateCoffee.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 25.10.25.
//
import Foundation

@MainActor struct CreateCoffee {
    let repository: CoffeeRepository
    
    func callAsFunction(creationRequest: CreateCoffeeRequest) throws -> Coffee {
        let newCoffee = Coffee(
            name: creationRequest.name,
            roaster: creationRequest.roaster,
            roastCategory: creationRequest.roastCategory.rawValue,
            roastDate: creationRequest.roastDate,
            rating: creationRequest.rating,
            notes: creationRequest.notes
        )
        return try repository.create(newCoffee)
    }
}
