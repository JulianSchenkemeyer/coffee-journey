//
//  RouterView.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 16.02.26.
//

import SwiftUI

/// A reusable navigation wrapper that provides centralized navigation destination handling.
/// Wraps content in a NavigationStack bound to the Router's path and handles all route destinations.
struct RouterView<Content: View>: View {
    @Environment(\.router) private var router
    
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        @Bindable var router = router
        
        NavigationStack(path: $router.path) {
            content()
                .navigationDestination(for: Router.Route.self) { route in
                    destinationView(for: route)
                }
        }
    }
    
    // MARK: - Navigation Destinations
    
    /// Maps route cases to their corresponding destination views
    @ViewBuilder
    private func destinationView(for route: Router.Route) -> some View {
        switch route {
        case .coffeeDetails(let coffee):
            CoffeeDetailsView(coffee: coffee)
        case .brewHistory(let coffee, let recipe):
            BrewHistoryView(coffee: coffee, recipe: recipe)
        case .equipmentDetails(let equipment):
            EquipmentDetailsView(equipment: equipment)
        }
    }
}
