//
//  Router.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 09.02.26.
//

import SwiftUI

@Observable
class Router {
    /// The detail column's subject. `path` holds only the pushes within it.
    var selection: Route?
    var path: [Route] = []

    enum Route: Hashable {
        case coffeeDetails(Coffee)
        case editCoffee(Coffee)
        case brewHistory(Coffee, Recipe?)
        case equipmentDetails(Equipment)

        /// How this route's destination animates in. Changing a case here is enough to switch a
        /// route's style: `RouterView` reads it to pick the transition, and `zoomSource(_:)` goes
        /// inert for anything that isn't `.zoom`, so source views need no edits.
        var transition: ZoomTransitionStyle {
            switch self {
            case .coffeeDetails: .standard
            case .equipmentDetails: .standard
            // Both are reached from menus rather than a tap on the zoomed view, so the morph
            // reads as arbitrary. Flip to `.zoom` and re-add a `zoomSource(_:)` anchor to revisit.
            case .editCoffee: .standard
            case .brewHistory: .standard
            }
        }
    }

    // Navigation methods
    func navigate(to route: Route) {
        path.append(route)
    }

    func navigateBack() {
        if path.isEmpty {
            selection = nil
        } else {
            path.removeLast()
        }
    }

    func navigateToRoot() {
        path.removeAll()
    }

    func pop(count: Int = 1) {
        guard path.count >= count else {
            path.removeAll()
            return
        }
        path.removeLast(count)
    }
}

// Environment key for Router
private struct RouterKey: EnvironmentKey {
    static let defaultValue = Router()
}

extension EnvironmentValues {
    var router: Router {
        get { self[RouterKey.self] }
        set { self[RouterKey.self] = newValue }
    }
}
