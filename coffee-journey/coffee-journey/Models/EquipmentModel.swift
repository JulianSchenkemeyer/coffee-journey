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

typealias Equipment = SchemaV4.Equipment


extension Equipment {
    var type: EquipmentType {
        EquipmentType(rawValue: typeDescription) ?? .machine
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
