//
//  Container.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 16.11.25.
//

import SwiftData


@MainActor
enum Container {
    
    static func create(configuration: [ModelConfiguration]) -> ModelContainer {
        let schema = Schema([Coffee.self, Equipment.self])
        return try! ModelContainer(for: schema, configurations: configuration)
    }
    
    static func createInMemory() -> ModelContainer {
        create(configuration: [ModelConfiguration(isStoredInMemoryOnly: true)])
    }
    
    static func createDefault() -> ModelContainer {
        create(configuration: [ModelConfiguration(isStoredInMemoryOnly: false)])
    }
}
