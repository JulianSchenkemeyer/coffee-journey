//
//  ZoomTransition.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 05.09.26.
//

import SwiftUI


// MARK: - Namespace environment

private struct NavigationNamespaceKey: EnvironmentKey {
    // Namespace.ID has no public initializer, so there is no real default here. Sources no-op while
    // this is nil, which keeps previews that mount a view outside of a RouterView working.
    static let defaultValue: Namespace.ID? = nil
}

extension EnvironmentValues {
    var navigationNamespace: Namespace.ID? {
        get { self[NavigationNamespaceKey.self] }
        set { self[NavigationNamespaceKey.self] = newValue }
    }
}


// MARK: - Source modifier

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
