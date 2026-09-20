//
//  SampleDataSeeder.swift
//  coffee-journey
//

import Foundation
import SwiftData

#if DEBUG

/// Fills the on-disk (simulator) store with `SampleDataFactoryV2` data when the app
/// is launched with the `-seedSampleData` argument — Xcode: Edit Scheme → Run →
/// Arguments → "Arguments Passed On Launch".
///
/// Only an empty store is seeded, so the flag can stay enabled without wiping
/// data created while using the app. To re-seed, delete the app from the
/// simulator (or Device → Erase All Content and Settings) and launch again.
@MainActor
enum SampleDataSeeder {
    private static let launchArgument = "-seedSampleData"

    static func seedIfRequested(_ context: ModelContext) {
        guard ProcessInfo.processInfo.arguments.contains(launchArgument) else { return }

        do {
            guard try context.fetchCount(FetchDescriptor<Coffee>()) == 0 else {
                print("[SampleDataSeeder] Store is not empty, skipping seed.")
                return
            }
            try SampleDataFactoryV2.seedContext(context)
            print("[SampleDataSeeder] Seeded sample data.")
        } catch {
            print("[SampleDataSeeder] Seeding failed: \(error)")
        }
    }
}

#endif
