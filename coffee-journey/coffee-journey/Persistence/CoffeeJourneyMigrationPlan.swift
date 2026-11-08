
//
//  CoffeeJourneyMigrationPlan.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 19.03.26.
//

import Foundation
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
        [SchemaV1.self, SchemaV2.self, SchemaV3.self, SchemaV4.self, SchemaV5.self, SchemaV6.self]
    }

    static var stages: [MigrationStage] {
        [
            // Lightweight: Equipment gains `maintenanceCounter: Int?`.
            // Optional columns are allowed by lightweight migration — existing rows
            // get nil, new Equipment instances start at nil (treat nil as 0 at the call site).
            .lightweight(fromVersion: SchemaV1.self, toVersion: SchemaV2.self),
            .lightweight(fromVersion: SchemaV2.self, toVersion: SchemaV3.self),
            // Lightweight: Brew gains `clarity: Int?`.
            // Optional column — existing rows get nil (clarity not recorded for old brews).
            .lightweight(fromVersion: SchemaV3.self, toVersion: SchemaV4.self),
            // Lightweight: Equipment gains `grinderOptions: GrinderOptions?`.
            // Optional composite attribute — existing rows get nil (no options configured).
            .lightweight(fromVersion: SchemaV4.self, toVersion: SchemaV5.self),
            // Custom: Recipe loses `name` and is identified by its brewer + grinder pair instead.
            // Recipes sharing a pair on the same coffee are merged before the column is dropped.
            .custom(
                fromVersion: SchemaV5.self,
                toVersion: SchemaV6.self,
                willMigrate: { context in
                    try mergeRecipesSharingEquipmentPair(in: context)
                },
                didMigrate: nil
            )
        ]
    }

    /// The most recently used recipe of each coffee + brewer + grinder group survives: its ranges
    /// widen to cover the whole group and it takes over the group's brews. Recipes missing a
    /// coffee, brewer or grinder have nothing to merge on and are kept as they are.
    static func mergeRecipesSharingEquipmentPair(in context: ModelContext) throws {
        let recipes = try context.fetch(FetchDescriptor<SchemaV5.Recipe>())
        let identifiable = recipes.filter { $0.coffee != nil && $0.brewer != nil && $0.grinder != nil }
        let groups = Dictionary(grouping: identifiable) {
            [$0.coffee?.persistentModelID, $0.brewer?.persistentModelID, $0.grinder?.persistentModelID]
        }

        for group in groups.values where group.count > 1 {
            let byLastUsed = group.sorted { ($0.lastUsed ?? .distantPast) > ($1.lastUsed ?? .distantPast) }
            guard let survivor = byLastUsed.first else { continue }

            for duplicate in byLastUsed.dropFirst() {
                survivor.minTemperature = min(survivor.minTemperature, duplicate.minTemperature)
                survivor.maxTemperature = max(survivor.maxTemperature, duplicate.maxTemperature)
                survivor.minGrindSetting = min(survivor.minGrindSetting, duplicate.minGrindSetting)
                survivor.maxGrindSetting = max(survivor.maxGrindSetting, duplicate.maxGrindSetting)
                survivor.minExtractionTime = min(survivor.minExtractionTime, duplicate.minExtractionTime)
                survivor.maxExtractionTime = max(survivor.maxExtractionTime, duplicate.maxExtractionTime)
                survivor.minAmountBeans = min(survivor.minAmountBeans, duplicate.minAmountBeans)
                survivor.maxAmountBeans = max(survivor.maxAmountBeans, duplicate.maxAmountBeans)
                survivor.minOutput = min(survivor.minOutput, duplicate.minOutput)
                survivor.maxOutput = max(survivor.maxOutput, duplicate.maxOutput)

                // Copy first: reassigning a brew removes it from `duplicate.brews`.
                for brew in Array(duplicate.brews) {
                    brew.recipe = survivor
                }
                context.delete(duplicate)
            }
        }

        try context.save()
    }
}
