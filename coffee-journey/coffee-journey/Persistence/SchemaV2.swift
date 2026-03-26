//
//  SchemaV2.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 19.03.26.
//

import SwiftData


/// Version 2 of the Coffee Journey schema.
///
/// Changes from V1:
/// - `Equipment` gains `maintenanceCounter: Int` (default 0, lightweight migration).
enum SchemaV2: VersionedSchema {
    static var versionIdentifier: Schema.Version { .init(2, 0, 0) }

    static var models: [any PersistentModel.Type] {
        [
            Coffee.self,
            Recipe.self,
            Equipment.self,
            Brew.self,
            Refill.self,
            MaintenanceTemplate.self,
            MaintenanceTemplateStep.self,
            MaintenanceInstance.self,
        ]
    }
}
