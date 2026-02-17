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
                destinationView(for: sheet)
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
        case .addCoffee(let coffee):
            CoffeeFormView(coffee: coffee)
        case .editRecipe(let coffee, let recipe):
            RecipeFormView(coffee: coffee, recipe: recipe)
        case .confirmRecipeCalibration(let recipe, let brew):
            ConfirmCalibrationModalView(recipe: recipe, brew: brew)
                .presentationDetents([.fraction(0.45)])
        }
    }
}
