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
    @Relationship(deleteRule: .cascade, inverse: \Refill.coffee) var refills: [Refill]
    @Relationship(deleteRule: .cascade, inverse: \Brew.coffee) var brews: [Brew]
    @Relationship(deleteRule: .cascade, inverse: \Recipe.coffee) var recipes: [Recipe]
    var amountLeft: Double
    
    var totalBrews: Int
    var brewsSinceRefill: Int
    
    var rating: Double
    var notes: String
    
    
    var lastUsedRecipe: Recipe? {
        recipes.max(by: { $0.lastUsed ?? .distantPast < $1.lastUsed ?? .distantPast })
    }
    
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
        brews: [Brew],
        recipes: [Recipe],
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
        self.brews = brews
        self.recipes = recipes
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
        self.brews = []
        self.recipes = []
        self.amountLeft = 0
        self.totalBrews = 0
        self.brewsSinceRefill = 0
        self.rating = 0.0
        self.notes = ""
    }
}


extension Coffee: SearchableModel {
    static func search(for term: String) -> Predicate<Coffee>? {
        let t = term.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !t.isEmpty else { return nil }
        
        return #Predicate<Coffee> { item in
            if term.isEmpty {
                return true
            } else {
                return item.name.contains(t) || item.roaster.contains(t)
            }
        }
    }
}
