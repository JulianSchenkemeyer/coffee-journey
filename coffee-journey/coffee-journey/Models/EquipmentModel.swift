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
