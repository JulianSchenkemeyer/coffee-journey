//
//  EquipmentModel.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 30.10.25.
//

import Foundation
import SwiftData


enum EquipmentType: String, Codable, CaseIterable, CustomStringConvertible {
    case machine = "Espresso Maschine"
    case grinder
    case kettle
    case milkFrother = "Milk Frother"
    
    
    var description: String {
        self.rawValue
    }
}

@Model final class Equipment: Identifiable {
    var brewerRecipes: [Recipe]
    var grinderRecipes: [Recipe]
    
    var name: String
    var brand: String
    var typeDescription: String
    var type: EquipmentType {
        EquipmentType(rawValue: typeDescription) ?? .machine
    }
    var notes: String
    // last maintenance + maintenance intervall reminder?
    
    init(name: String, brand: String, type: String, notes: String) {
        self.name = name
        self.brand = brand
        self.typeDescription = type
        self.notes = notes
        self.brewerRecipes = []
        self.grinderRecipes = []
    }
    
    // Convenience initializer with sensible defaults for SwiftData
    init() {
        self.name = ""
        self.brand = ""
        self.typeDescription = EquipmentType.machine.rawValue
        self.notes = ""
        self.brewerRecipes = []
        self.grinderRecipes = []
    }
}


extension Equipment {
    // Predicates for use with @Query — #Predicate only supports local variable captures
    // on the right-hand side, so these are defined here rather than inline at the call site.
    static var isBrewer: Predicate<Equipment> {
        let type = EquipmentType.machine.rawValue
        return #Predicate<Equipment> { $0.typeDescription == type }
    }

    static var isGrinder: Predicate<Equipment> {
        let type = EquipmentType.grinder.rawValue
        return #Predicate<Equipment> { $0.typeDescription == type }
    }
}

extension Equipment: SearchableModel {
    static func search(for term: String) -> Predicate<Equipment>? {
        let t = term.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !t.isEmpty else { return nil }
        
        return #Predicate<Equipment> { item in
            if term.isEmpty {
                return true
            } else {
                return item.name.contains(t) || item.brand.contains(t) || item.typeDescription.contains(t)
            }
        }
    }
}
