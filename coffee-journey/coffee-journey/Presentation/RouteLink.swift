//
//  RouteLink.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 05.09.26.
//

import SwiftUI

/// A `NavigationLink` that also anchors the route's zoom transition, so the route is named once
/// instead of once for the link value and once for the transition source.
struct RouteLink<Label: View>: View {
    private let route: Router.Route
    private let label: () -> Label

    init(_ route: Router.Route, @ViewBuilder label: @escaping () -> Label) {
        self.route = route
        self.label = label
    }

    var body: some View {
        NavigationLink(value: route) {
            label()
        }
        .zoomSource(route)
    }
}
