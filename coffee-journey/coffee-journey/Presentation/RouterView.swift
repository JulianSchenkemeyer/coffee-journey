//
//  RouterView.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 16.02.26.
//

import SwiftUI

/// The detail column of a shelf's `NavigationSplitView`: it renders whichever route the sidebar
/// selected and owns the stack of pushes within it. The sidebar picks the subject
/// (`Router.selection`); this view handles where you are inside that subject (`Router.path`).
struct RouterView: View {
    @Environment(\.router) private var router

    /// Shared by every zoom transition in this stack. Published into the environment so sources
    /// anywhere in the subtree can reach it without being passed the namespace explicitly.
    @Namespace private var navigationNamespace

    var body: some View {
        @Bindable var router = router

        NavigationStack(path: $router.path) {
            Group {
                if let root = router.selection {
                    destinationContent(for: root)
                } else {
                    ContentUnavailableView("No Selection", systemImage: CJSymbol.Navigation.coffee)
                }
            }
            // Outside the `if` so the destination stays registered while nothing is selected.
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
