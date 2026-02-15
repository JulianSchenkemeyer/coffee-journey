//
//  CheckCoffeeExists.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 15.02.26.
//

import Foundation

struct CheckCoffeeExists {
    let repository: CoffeeRepository
    
    @MainActor
    func callAsFunction(name: String, roaster: String, excluding: Coffee? = nil) throws -> Bool {
        return try repository.exists(name: name, roaster: roaster, excluding: excluding)
    }
}
