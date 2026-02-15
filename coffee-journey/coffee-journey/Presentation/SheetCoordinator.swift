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
        case addCoffee(Coffee?)
        case editRecipe(Coffee, Recipe?)
        
        var id: String {
            switch self {
            case .brew: "brew"
            case .refill: "refill"
            case .addCoffee: "addCoffee"
            case .editRecipe: "editRecipe"
            }
        }
    }
    
    var activeSheet: ActiveSheet?
    
    func present(_ sheet: ActiveSheet) {
        activeSheet = sheet
    }
    
    func dismiss() {
        activeSheet = nil
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
