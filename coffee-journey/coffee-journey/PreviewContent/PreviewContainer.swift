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
    
    /// Create an in-memory ModelContainer and seed it with the provided instances.
    /// - Parameter instances: Array of PersistentModel instances to insert.
    /// - Returns: A ModelContainer seeded with the provided instances.
    public static func seeded(with instances: [any PersistentModel]) -> ModelContainer {
        let container = ContainerFactory.createInMemory()
        let context = ModelContext(container)

        for instance in instances {
            context.insert(instance)
        }
        try? context.save()
        return container
    }
}
#endif

