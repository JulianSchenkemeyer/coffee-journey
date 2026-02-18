//
//  CreateEquipmentRequest.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 30.10.25.
//

import Foundation

enum EquipmentType: String, Codable, CaseIterable {
    case kettle
    case grinder
    case scale
    case milkFrother = "Milk Frother"
    case mug
    case machine = "Espresso Maschine"
}

struct CreateEquipmentRequest {
    let name: String
    let brand: String
    let type: EquipmentType
    let notes: String
}

