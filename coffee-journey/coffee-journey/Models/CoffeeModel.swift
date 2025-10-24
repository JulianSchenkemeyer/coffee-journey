//
//  CoffeeModel.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 24.10.25.
//

import Foundation
import SwiftData


@Model final class Coffee: Identifiable {
    var name: String
    var roaster: String
    var roastCategory: String
    
    var roastDate: Date
    var rating: Double
    var notes: String
    
    init(
        name: String,
        roaster: String,
        roastCategory: String,
        roastDate: Date,
        rating: Double,
        notes: String
    ) {
        self.name = name
        self.roaster = roaster
        self.roastCategory = roastCategory
        self.roastDate = roastDate
        self.rating = rating
        self.notes = notes
    }

    // Convenience initializer with sensible defaults for SwiftData
    init() {
        self.name = ""
        self.roaster = ""
        self.roastCategory = ""
        self.roastDate = Date()
        self.rating = 0.0
        self.notes = ""
    }
}
