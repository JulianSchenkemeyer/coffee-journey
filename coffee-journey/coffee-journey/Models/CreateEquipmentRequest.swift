//
//  CreateEquipmentRequest.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 30.10.25.
//

import Foundation

enum EquipmentType: String, Codable, CaseIterable {
    case kettle, grinder, scale, milkFrother, mug, machine, dripper, filter
}

struct CreateEquipmentRequest {
    let name: String
    let brand: String
    let type: EquipmentType
    let notes: String
}

