//
//  AlertCoordinatorView.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 06.03.26.
//
import SwiftUI

/// A reusable alert presentation wrapper that provides centralized alert handling.
/// Wraps content with an alert modifier bound to the AlertCoordinator's state.
struct AlertCoordinatorView<Content: View>: View {
    @Environment(\.alertCoordinator) private var alertCoordinator

    @ViewBuilder var content: () -> Content

    var body: some View {
        @Bindable var alertCoordinator = alertCoordinator

        content()
            .alert(
                alertCoordinator.activeAlert?.title ?? "",
                isPresented: Binding(
                    get: { alertCoordinator.activeAlert != nil },
                    set: { if !$0 { alertCoordinator.dismiss() } }
                )
            ) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(alertCoordinator.activeAlert?.message ?? "")
            }
    }
}
