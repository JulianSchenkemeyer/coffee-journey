//
//  CreateCoffeeRequest.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 27.10.25.
//

import Foundation


enum CoffeeCreationError: Error {
    case emptyName
    case invalidRating
}

enum RoastCategory: String, Codable, CaseIterable {
    case light, medium, dark
}

struct CreateCoffeeRequest {
    let name: String
    let roaster: String
    let roastCategory: RoastCategory
    let amount: Double
    let roastDate: Date
    let rating: Double
    let notes: String
}
