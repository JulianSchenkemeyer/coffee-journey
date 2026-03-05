//
//  UpdateCoffeeRequest.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 05.03.26.
//

import Foundation


struct UpdateCoffeeRequest {
    let name: String
    let roaster: String
    let roastCategory: RoastCategory
    let rating: Double
    let notes: String
}
