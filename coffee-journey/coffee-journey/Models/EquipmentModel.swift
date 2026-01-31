//
//  EquipmentModel.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 30.10.25.
//

import Foundation
import SwiftData

@Model final class Equipment: Identifiable {
    var name: String
    var brand: String
    var type: String
    var notes: String
    // last maintenance + maintenance intervall reminder?
    
    init(name: String, brand: String, type: String, notes: String) {
        self.name = name
        self.brand = brand
        self.type = type
        self.notes = notes
    }
    
    // Convenience initializer with sensible defaults for SwiftData
    init() {
        self.name = ""
        self.brand = ""
        self.type = ""
        self.notes = ""
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
                return item.name.contains(t) || item.brand.contains(t) || item.type.contains(t)
            }
        }
    }
}
