//
//  Recipe+EquipmentPair.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 04.11.26.
//
import Foundation


extension Recipe {
    var equipmentPairName: String {
        switch (brewer?.name, grinder?.name) {
        case let (brewer?, grinder?):
            "\(brewer) · \(grinder)"
        case let (brewer?, nil):
            "\(brewer) · \(String(localized: "Unknown Grinder"))"
        case let (nil, grinder?):
            "\(String(localized: "Unknown Brewer")) · \(grinder)"
        case (nil, nil):
            String(localized: "Unknown Equipment")
        }
    }
}
