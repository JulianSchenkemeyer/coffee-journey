//
//  SheetCoordinator.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 09.02.26.
//
import Foundation
import SwiftUI


@Observable class SheetCoordinator {
    enum ActiveSheet: Identifiable {
        case brew(Coffee)
        case refill(Coffee)
        case addCoffee
        case editRecipe(Coffee, Recipe?)
        case confirmRecipeCalibration(Recipe, CalibrateRecipeRequest)
        case confirmEmptying(Coffee)
        case addEquipment(Equipment?)
        case maintenanceTemplate(MaintenanceTemplate)
        
        var id: String {
            switch self {
            case .brew: "brew"
            case .refill: "refill"
            case .addCoffee: "addCoffee"
            case .editRecipe: "editRecipe"
            case .confirmRecipeCalibration: "confirmRecipeCalibration"
            case .addEquipment: "addEquipment"
            case .confirmEmptying: "confirmEmptying"
            case .maintenanceTemplate: "maintenanceTemplate"
            }
        }
    }
    
    var activeSheet: ActiveSheet?
    
    /// The control the active sheet should zoom out of, declared by whoever presented it. A sheet
    /// presented without an anchor uses the default slide-up — which is every trigger that isn't a
    /// stable, tappable control (swipe actions, menu items).
    private(set) var zoomAnchor: SheetAnchor?
    
    func present(_ sheet: ActiveSheet, from anchor: SheetAnchor? = nil) {
        zoomAnchor = anchor
        activeSheet = sheet
    }
    
    func dismiss() {
        activeSheet = nil
        // zoomAnchor deliberately left set: the dismissal animation still needs it to collapse back
        // into. Every `present` overwrites it, so a stale value is never read.
    }
}

// Environment key for SheetManager
private struct SheetCoordinatorKey: EnvironmentKey {
    static let defaultValue = SheetCoordinator()
}

extension EnvironmentValues {
    var sheetCoordinator: SheetCoordinator {
        get { self[SheetCoordinatorKey.self] }
        set { self[SheetCoordinatorKey.self] = newValue }
    }
}
