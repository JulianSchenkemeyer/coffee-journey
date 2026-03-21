
//
//  CoffeeJourneyMigrationPlan.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 19.03.26.
//

import SwiftData


/// Describes the evolution of the Coffee Journey schema across versions.
///
/// Add a new `MigrationStage` entry here whenever the data model changes.
/// Use `.lightweight` for additive changes (new properties with defaults,
/// renamed properties) and `.custom` when data transformation is required.
///
/// Example for adding a future V2:
/// ```swift
/// .lightweight(fromVersion: SchemaV1.self, toVersion: SchemaV2.self)
/// ```
enum CoffeeJourneyMigrationPlan: SchemaMigrationPlan {

    static var schemas: [any VersionedSchema.Type] {
        [SchemaV1.self, SchemaV2.self]
    }

    static var stages: [MigrationStage] {
        [
            // Lightweight: Equipment gains `maintenanceCounter: Int?`.
            // Optional columns are allowed by lightweight migration — existing rows
            // get nil, new Equipment instances start at nil (treat nil as 0 at the call site).
            .lightweight(fromVersion: SchemaV1.self, toVersion: SchemaV2.self),
        ]
    }
}
