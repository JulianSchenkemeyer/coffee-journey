//
//  SheetCoordinatorView.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 16.02.26.
//

import SwiftUI

/// A reusable modal presentation wrapper that provides centralized sheet destination handling.
/// Wraps content with a sheet modifier bound to the SheetCoordinator's state and handles all sheet destinations.
struct SheetCoordinatorView<Content: View>: View {
    @Environment(\.sheetCoordinator) private var sheetCoordinator
    
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        @Bindable var sheetCoordinator = sheetCoordinator
        
        content()
            .sheet(item: $sheetCoordinator.activeSheet) { sheet in
                AlertCoordinatorView {
                    destinationView(for: sheet)
                }
            }
    }
    
    // MARK: - Sheet Destinations
    
    /// Maps sheet cases to their corresponding destination views
    @ViewBuilder
    private func destinationView(for sheet: SheetCoordinator.ActiveSheet) -> some View {
        switch sheet {
        case .brew(let coffee):
            BrewDrinkModalView(coffee: coffee)
                .presentationDetents([.fraction(0.9)])
        case .refill(let coffee):
            RefillBeansModalView(coffee: coffee)
                .presentationDetents([.medium])
        case .confirmEmptying(let coffee):
            ConfirmEmptyingModalView(coffee: coffee)
                .presentationDetents([.fraction(0.25)])
        case .addCoffee(let coffee):
            AddCoffeeModalView(coffee: coffee)
        case .editRecipe(let coffee, let recipe):
            RecipeFormView(coffee: coffee, recipe: recipe)
        case .confirmRecipeCalibration(let recipe, let request):
            ConfirmCalibrationModalView(recipe: recipe, request: request)
                .presentationDetents([.fraction(0.45)])
        case .addEquipment(let equipment):
            EquipmentFormView(equipment: equipment)
        case .maintenanceTemplate(let template):
            MaintenanceView(maintenanceTemplate: template)
        }
    }
}
