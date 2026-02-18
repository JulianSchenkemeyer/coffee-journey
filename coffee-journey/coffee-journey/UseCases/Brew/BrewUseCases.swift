//
//  BrewUseCases.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 18.02.26.
//

//
//  CoffeeUseCases.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 15.02.26.
//

import Foundation
import SwiftUI
import SwiftData


struct BrewUseCases {
    var update: @MainActor (Brew) throws -> Brew
    var delete: @MainActor (Brew) throws -> Void
}

enum BrewUseCaseFactory {
    
    @MainActor
    static func make(repository: SwiftDataBrewRepository) -> BrewUseCases {
        let update = UpdateBrew(repository: repository).callAsFunction
        let delete = DeleteBrew(repository: repository).callAsFunction
        
        return BrewUseCases(
            update: update,
            delete: delete,
        )
    }
}

extension EnvironmentValues {
    @Entry var brewUseCases: BrewUseCases = {
        return BrewUseCases(
            update: { _ in
                fatalError("CoffeeUseCases not injected")
            },
            delete: { _ in
                fatalError("CoffeeUseCases not injected")
            },
        )
    }()
}
