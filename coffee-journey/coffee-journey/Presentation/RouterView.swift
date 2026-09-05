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

    /// Shared by every zoom transition in this stack. Published into the environment so sources
    /// anywhere in the subtree can reach it without being passed the namespace explicitly.
    @Namespace private var navigationNamespace

    @ViewBuilder var content: () -> Content

    var body: some View {
        @Bindable var router = router

        NavigationStack(path: $router.path) {
            content()
                .navigationDestination(for: Router.Route.self) { route in
                    destinationView(for: route)
                }
        }
        .environment(\.navigationNamespace, navigationNamespace)
    }

    // MARK: - Navigation Destinations

    /// Applies the transition the route declares. The route is its own zoom source identity, so no
    /// separate mapping is needed; routes whose `zoomSource(_:)` anchor isn't on screen fall back
    /// to the default push on their own.
    @ViewBuilder
    private func destinationView(for route: Router.Route) -> some View {
        switch route.transition {
        case .zoom:
            destinationContent(for: route)
                .navigationTransition(.zoom(sourceID: route, in: navigationNamespace))
        case .standard:
            destinationContent(for: route)
        }
    }

    /// Maps route cases to their corresponding destination views
    @ViewBuilder
    private func destinationContent(for route: Router.Route) -> some View {
        switch route {
        case .coffeeDetails(let coffee):
            CoffeeDetailsView(coffee: coffee)
        case .editCoffee(let coffee):
            CoffeeEditView(coffee: coffee)
        case .brewHistory(let coffee, let recipe):
            BrewHistoryView(coffee: coffee, recipe: recipe)
        case .equipmentDetails(let equipment):
            EquipmentDetailsView(equipment: equipment)
        }
    }
}
