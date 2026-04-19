//
//  CoffeeModel.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 24.10.25.
//

import Foundation
import SwiftData


typealias Coffee = SchemaV3.Coffee


extension Coffee {
    var lastUsedRecipe: Recipe? {
        recipes.max(by: { $0.lastUsed ?? .distantPast < $1.lastUsed ?? .distantPast })
    }
    
    var newestRefill: Refill? {
        refills.max(by: { $0.date < $1.date })
    }
    
    var beanAge: Int? {
        guard let roastDate = newestRefill?.roastDate else {
            return nil
        }
        
        return Calendar.current.dateComponents([.day], from: roastDate, to: .now).day
    }
    
    var amount: Double {
        newestRefill?.amount ?? 0
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
