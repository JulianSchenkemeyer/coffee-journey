//
//  Container.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 16.11.25.
//

import SwiftData


@MainActor
enum ContainerFactory {
    
    static func create(configuration: [ModelConfiguration]) -> ModelContainer {
        return try! ModelContainer(
            for: Schema(SchemaV2.models),
            migrationPlan: CoffeeJourneyMigrationPlan.self,
            configurations: configuration
        )
    }
    
    static func createInMemory() -> ModelContainer {
        create(configuration: [ModelConfiguration(isStoredInMemoryOnly: true)])
    }
    
    static func createDefault() -> ModelContainer {
        create(configuration: [ModelConfiguration(isStoredInMemoryOnly: false)])
    }
}
