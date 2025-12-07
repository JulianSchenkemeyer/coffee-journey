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
    
    var lastRefill: Date
    var refills: [Refill]
    var amountLeft: Double
    
    var totalBrews: Int
    var brewsSinceRefill: Int
    
    var rating: Double
    var notes: String
    
    
    var newestRefill: Refill? {
        refills.max(by: { $0.date < $1.date })
    }
    var amount: Double {
        newestRefill?.amount ?? 0
    }
    
    
    init(
        name: String,
        roaster: String,
        roastCategory: String,
        amount: Double,
        amountLeft: Double,
        lastRefill: Date,
        totalBrews: Int,
        brewsSinceRefill: Int,
        roastDate: Date,
        rating: Double,
        notes: String
    ) {
        self.name = name
        self.roaster = roaster
        self.roastCategory = roastCategory
        self.lastRefill = lastRefill
        self.amountLeft = amountLeft
        self.refills = [.init(amount: amount, roastDate: roastDate, date: .now)]
        self.totalBrews = totalBrews
        self.brewsSinceRefill = brewsSinceRefill
        self.rating = rating
        self.notes = notes
    }

    // Convenience initializer with sensible defaults for SwiftData
    init() {
        self.name = ""
        self.roaster = ""
        self.roastCategory = ""
        self.refills = []
        self.lastRefill = .now
        self.amountLeft = 0
        self.totalBrews = 0
        self.brewsSinceRefill = 0
        self.rating = 0.0
        self.notes = ""
    }
}
