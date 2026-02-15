//
//  Router.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 09.02.26.
//

import SwiftUI

@Observable
class Router {
    var path: [Route] = []
    
    enum Route: Hashable {
        case coffeeDetails(Coffee)
        case brewHistory(Coffee, Recipe?)
        case equipmentDetails(Equipment)
    }
    
    // Navigation methods
    func navigate(to route: Route) {
        path.append(route)
    }
    
    func navigateBack() {
        guard !path.isEmpty else { return }
        path.removeLast()
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
