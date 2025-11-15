//
//  PreviewContainer.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 15.11.25.
//

import Foundation
import SwiftData

#if DEBUG
public enum PreviewContainer {
    /// Returns an in-memory ModelContainer for the provided models, without seeding any data.
    public static func empty(for modelTypes: [any PersistentModel.Type]) -> ModelContainer {
        let schema = Schema(modelTypes)
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        return try! ModelContainer(for: schema, configurations: [configuration])
    }

    /// Backwards-compatible helper for the previous fixed schema (Coffee, Equipment)
    /// Remove this if you no longer need the concrete convenience.
    public static func empty() -> ModelContainer {
        let schema = Schema([Coffee.self, Equipment.self])
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        return try! ModelContainer(for: schema, configurations: [configuration])
    }

    /// Create an in-memory ModelContainer and seed it with the provided instances.
    /// - Parameter instances: Array of PersistentModel instances to insert.
    /// - Returns: A ModelContainer seeded with the provided instances.
    public static func seeded(with instances: [any PersistentModel]) -> ModelContainer {
        let container = empty()
        let context = ModelContext(container)

        for instance in instances {
            context.insert(instance)
        }
        try? context.save()
        return container
    }

    /// Create an in-memory ModelContainer for explicit model types and seed it with provided instances.
    /// Useful when you want to control the schema explicitly (e.g., include related types even if not present in instances).
    /// - Parameters:
    ///   - modelTypes: The model types to include in the schema.
    ///   - instances: Instances to insert.
    public static func seeded(for modelTypes: [any PersistentModel.Type], with instances: [any PersistentModel]) -> ModelContainer {
        let container = empty(for: modelTypes)
        let context = ModelContext(container)

        for instance in instances {
            context.insert(instance)
        }
        try? context.save()
        return container
    }
}
#endif

