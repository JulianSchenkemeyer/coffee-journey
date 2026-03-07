//
//  AlertCoordinatorView.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 06.03.26.
//
import SwiftUI

/// A reusable alert presentation wrapper that provides centralized alert handling.
/// Wraps content with an alert modifier bound to a locally-scoped AlertCoordinator,
/// which is injected into the environment so child views can trigger alerts via
/// @Environment(\.alertCoordinator). Each usage gets its own isolated coordinator,
/// preventing alert state from leaking between root and sheet contexts.
struct AlertCoordinatorView<Content: View>: View {
    @State private var alertCoordinator = AlertCoordinator()

    @ViewBuilder var content: () -> Content

    var body: some View {
        @Bindable var alertCoordinator = alertCoordinator

        content()
            .environment(\.alertCoordinator, alertCoordinator)
            .alert(
                alertCoordinator.activeAlert?.title ?? "",
                isPresented: Binding(
                    get: { alertCoordinator.activeAlert != nil },
                    set: { if !$0 { alertCoordinator.dismiss() } }
                )
            ) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(alertCoordinator.activeAlert?.description ?? "")
            }
    }
}
