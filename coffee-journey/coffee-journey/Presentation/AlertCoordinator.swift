//
//  AlertCoordinator.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 06.03.26.
//
import Foundation
import SwiftUI


@Observable class AlertCoordinator {
    struct AlertContent: Identifiable {
        let id = UUID()
        let title: String
        let message: String
    } 

    var activeAlert: AlertContent?

    func show(title: String, message: String) {
        activeAlert = AlertContent(title: title, message: message)
    }

    func show(error: Error) {
        activeAlert = AlertContent(
            title: "Something went wrong",
            message: error.localizedDescription
        )
    }

    func dismiss() {
        activeAlert = nil
    }
}

// Environment key
private struct AlertCoordinatorKey: EnvironmentKey {
    static let defaultValue = AlertCoordinator()
}

extension EnvironmentValues {
    var alertCoordinator: AlertCoordinator {
        get { self[AlertCoordinatorKey.self] }
        set { self[AlertCoordinatorKey.self] = newValue }
    }
}
