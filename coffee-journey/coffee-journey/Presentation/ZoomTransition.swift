//
//  ZoomTransition.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 05.09.26.
//

import SwiftUI


/// How a destination animates in. Shared by `Router.Route` and `SheetCoordinator.ActiveSheet` so each
/// domain keeps its transition decision in one place.
enum ZoomTransitionStyle {
    case zoom
    case standard
}


// MARK: - Namespace environment

// Namespace.ID has no public initializer, so neither key can carry a real default. Anchors no-op while
// the value is nil, which keeps previews that mount a view outside its coordinator working.

private struct NavigationNamespaceKey: EnvironmentKey {
    static let defaultValue: Namespace.ID? = nil
}

private struct SheetNamespaceKey: EnvironmentKey {
    static let defaultValue: Namespace.ID? = nil
}

extension EnvironmentValues {
    var navigationNamespace: Namespace.ID? {
        get { self[NavigationNamespaceKey.self] }
        set { self[NavigationNamespaceKey.self] = newValue }
    }

    var sheetNamespace: Namespace.ID? {
        get { self[SheetNamespaceKey.self] }
        set { self[SheetNamespaceKey.self] = newValue }
    }
}


// MARK: - Anchors

private struct ZoomSourceModifier: ViewModifier {
    @Environment(\.navigationNamespace) private var namespace

    let route: Router.Route

    func body(content: Content) -> some View {
        if let namespace, case .zoom = route.transition {
            content.matchedTransitionSource(id: route, in: namespace)
        } else {
            content
        }
    }
}

extension View {
    /// Marks this view as the geometry a zoom transition grows out of and collapses back into.
    ///
    /// Only an anchor — whether the route actually zooms is decided by `Router.Route.transition`.
    /// A route set to `.standard` leaves every one of its anchors inert.
    func zoomSource(_ route: Router.Route) -> some View {
        modifier(ZoomSourceModifier(route: route))
    }
}

// MARK: - Sheet anchors

/// Identifies the individual control a sheet's zoom transition grows out of.
///
/// One case per trigger *site*, not per sheet: several controls can present the same sheet (`.refill`
/// alone has three), and `SheetCoordinator.ActiveSheet.id` is a constant per case, so it cannot tell them
/// apart. Whichever control presents the sheet declares its own anchor via `present(_:from:)`.
enum SheetAnchor: Hashable {
    case addCoffee
    case addEquipment
    case addRecipe(Coffee)
    case refillCoffee(Coffee)
    case brewCoffee(Coffee)
}

private struct SheetZoomSourceModifier: ViewModifier {
    @Environment(\.sheetNamespace) private var namespace

    let anchor: SheetAnchor

    func body(content: Content) -> some View {
        if let namespace {
            content.matchedTransitionSource(id: anchor, in: namespace)
        } else {
            content
        }
    }
}

extension View {
    /// Marks this view as the geometry a sheet's zoom transition grows out of.
    func sheetZoomSource(_ anchor: SheetAnchor) -> some View {
        modifier(SheetZoomSourceModifier(anchor: anchor))
    }
}

extension ToolbarContent {
    /// Marks this toolbar item as the geometry a sheet's zoom transition grows out of.
    ///
    /// `ToolbarContent` is the overload Apple documents for toolbar sources, and it cannot reach the
    /// environment through a `ViewModifier` — hence the namespace parameter.
    ///
    /// Deliberately unconditional and non-optional, matching the documented form. An earlier variant
    /// wrapped this in a `@ToolbarContentBuilder` `if/else` to absorb an optional namespace; it compiled,
    /// but the transition silently did not play.
    func sheetZoomSource(
        _ anchor: SheetAnchor,
        in namespace: Namespace.ID
    ) -> some ToolbarContent {
        matchedTransitionSource(id: anchor, in: namespace)
    }
}
