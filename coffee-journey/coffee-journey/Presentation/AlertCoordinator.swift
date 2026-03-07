//
//  AlertCoordinator.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 06.03.26.
//
import Foundation
import SwiftUI


enum AlertContent {
    case presentable(PresentableError)
    case generic(Error)
    case message(title: String, description: String)

    var title: String {
        switch self {
        case .presentable(let error): error.content.title
        case .generic: "Error"
        case .message(let title, _): title
        }
    }

    var description: String {
        switch self {
        case .presentable(let error): error.content.description
        case .generic(let error): error.localizedDescription
        case .message(_, let description): description
        }
    }
}


@Observable class AlertCoordinator {
    var activeAlert: AlertContent?

    func show(_ error: Error) {
        if let presentable = error as? PresentableError {
            activeAlert = .presentable(presentable)
        } else {
            activeAlert = .generic(error)
        }
    }

    func show(title: String, message: String) {
        activeAlert = .message(title: title, description: message)
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
