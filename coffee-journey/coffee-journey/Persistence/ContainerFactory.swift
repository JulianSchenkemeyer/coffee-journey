//
//  Container.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 16.11.25.
//

import Foundation
import SwiftData


@MainActor
enum ContainerFactory {
    private static let isPreview = ProcessInfo.processInfo
            .environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    
    static func create(configuration: [ModelConfiguration]) -> ModelContainer {
        do {
            return try ModelContainer(
                for: Schema(SchemaV4.models),
                migrationPlan: CoffeeJourneyMigrationPlan.self,
                configurations: configuration
            )
        } catch {
            fatalError("Create Failed")
        }
    }
    
    
    static func createInMemory() -> ModelContainer {
        do {
            return try ModelContainer(
                for: Schema(SchemaV4.models),
                configurations: [ModelConfiguration(isStoredInMemoryOnly: true)]
            )
        } catch {
            fatalError("CreateInMemory Failed")
        }
    }
    
    static func createDefault() -> ModelContainer {
        if isPreview {
            createInMemory()
        } else {
            create(configuration: [ModelConfiguration(isStoredInMemoryOnly: false)])
        }
    }
}
