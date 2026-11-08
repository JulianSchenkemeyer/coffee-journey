//
//  MigrationTests.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 08.11.26.
//
import Foundation
import Testing
import SwiftData
@testable import coffee_journey


@MainActor
struct CoffeeJourneyMigrationTests {

    // MARK: - Helpers

    private func makeStoreURL() -> URL {
        FileManager.default.temporaryDirectory.appending(path: "migration-\(UUID().uuidString).store")
    }

    private func removeStore(at url: URL) {
        for suffix in ["", "-shm", "-wal"] {
            try? FileManager.default.removeItem(at: URL(filePath: url.path() + suffix))
        }
    }

    private func makeV5Coffee(_ name: String) -> SchemaV5.Coffee {
        SchemaV5.Coffee(
            name: name,
            roaster: "Roaster",
            roastCategory: RoastCategory.light.rawValue,
            amount: 250,
            amountLeft: 250,
            lastRefill: .now,
            brews: [],
            recipes: [],
            totalBrews: 0,
            brewsSinceRefill: 0,
            roastDate: .now,
            rating: 0,
            notes: ""
        )
    }

    private func makeV5Recipe(
        coffee: SchemaV5.Coffee,
        brewer: SchemaV5.Equipment?,
        grinder: SchemaV5.Equipment?,
        temperature: ClosedRange<Int>,
        grind: ClosedRange<Double>,
        lastUsed: Date?
    ) -> SchemaV5.Recipe {
        let recipe = SchemaV5.Recipe(
            name: "Espresso",
            minTemperature: temperature.lowerBound,
            maxTemperature: temperature.upperBound,
            minGrindSetting: grind.lowerBound,
            maxGrindSetting: grind.upperBound,
            minExtractionTime: 28,
            maxExtractionTime: 32,
            minBeans: 18.0,
            maxBeans: 18.5,
            minOutput: 36.0,
            maxOutput: 37.0,
            brewer: brewer,
            grinder: grinder
        )
        recipe.coffee = coffee
        recipe.lastUsed = lastUsed
        return recipe
    }

    private func makeV5Brew(coffee: SchemaV5.Coffee, recipe: SchemaV5.Recipe) -> SchemaV5.Brew {
        let brew = SchemaV5.Brew(
            date: .now,
            beanAge: 10,
            amountCoffee: 18.0,
            grindSetting: 10.0,
            temperature: 93,
            extractionTime: 30,
            taste: 3,
            output: 36.0,
            rating: .thumbsUp
        )
        brew.coffee = coffee
        brew.recipe = recipe
        return brew
    }

    // Seeds a V5 store: Ethiopia has two recipes sharing Robot + C40 (one brew each), one
    // Robot + K-Ultra recipe and one recipe without a grinder; Kenya reuses Robot + C40.
    private func seedV5Store(at url: URL) throws {
        let container = try ModelContainer(
            for: Schema(versionedSchema: SchemaV5.self),
            configurations: ModelConfiguration(url: url)
        )
        let context = ModelContext(container)

        let ethiopia = makeV5Coffee("Ethiopia")
        let kenya = makeV5Coffee("Kenya")
        let robot = SchemaV5.Equipment(name: "Robot", brand: "Cafelat", type: EquipmentType.machine.rawValue, notes: "")
        let c40 = SchemaV5.Equipment(name: "C40", brand: "Comandante", type: EquipmentType.grinder.rawValue, notes: "")
        let kUltra = SchemaV5.Equipment(name: "K-Ultra", brand: "1Zpresso", type: EquipmentType.grinder.rawValue, notes: "")
        [ethiopia, kenya].forEach { context.insert($0) }
        [robot, c40, kUltra].forEach { context.insert($0) }

        let older = makeV5Recipe(coffee: ethiopia, brewer: robot, grinder: c40,
                                 temperature: 90...92, grind: 9...10, lastUsed: Date(timeIntervalSince1970: 100))
        let newer = makeV5Recipe(coffee: ethiopia, brewer: robot, grinder: c40,
                                 temperature: 93...95, grind: 11...12, lastUsed: Date(timeIntervalSince1970: 200))
        let unique = makeV5Recipe(coffee: ethiopia, brewer: robot, grinder: kUltra,
                                  temperature: 94...94, grind: 5...5, lastUsed: nil)
        let noGrinder = makeV5Recipe(coffee: ethiopia, brewer: robot, grinder: nil,
                                     temperature: 94...94, grind: 5...5, lastUsed: nil)
        let otherCoffee = makeV5Recipe(coffee: kenya, brewer: robot, grinder: c40,
                                       temperature: 96...96, grind: 8...8, lastUsed: nil)
        [older, newer, unique, noGrinder, otherCoffee].forEach { context.insert($0) }

        context.insert(makeV5Brew(coffee: ethiopia, recipe: older))
        context.insert(makeV5Brew(coffee: ethiopia, recipe: newer))

        try context.save()
    }

    private func openMigratedStore(at url: URL) throws -> ModelContainer {
        try ModelContainer(
            for: Schema(versionedSchema: SchemaV6.self),
            migrationPlan: CoffeeJourneyMigrationPlan.self,
            configurations: ModelConfiguration(url: url)
        )
    }

    private func recipes(of coffeeName: String, in context: ModelContext) throws -> [SchemaV6.Recipe] {
        try context.fetch(FetchDescriptor<SchemaV6.Recipe>()).filter { $0.coffee?.name == coffeeName }
    }

    // MARK: - V5 → V6

    @Test func migrationMergesRecipesSharingAPairOnTheSameCoffee() throws {
        let url = makeStoreURL()
        defer { removeStore(at: url) }
        try seedV5Store(at: url)

        let context = ModelContext(try openMigratedStore(at: url))

        let merged = try recipes(of: "Ethiopia", in: context)
            .filter { $0.brewer?.name == "Robot" && $0.grinder?.name == "C40" }
        #expect(merged.count == 1)
        #expect(merged.first?.brews.count == 2)
    }

    @Test func migrationWidensMergedRangesAndKeepsLatestLastUsed() throws {
        let url = makeStoreURL()
        defer { removeStore(at: url) }
        try seedV5Store(at: url)

        let context = ModelContext(try openMigratedStore(at: url))

        let merged = try #require(try recipes(of: "Ethiopia", in: context)
            .first { $0.brewer?.name == "Robot" && $0.grinder?.name == "C40" })
        #expect(merged.minTemperature == 90)
        #expect(merged.maxTemperature == 95)
        #expect(merged.minGrindSetting == 9.0)
        #expect(merged.maxGrindSetting == 12.0)
        #expect(merged.lastUsed == Date(timeIntervalSince1970: 200))
    }

    @Test func migrationKeepsRecipesThatAreNotDuplicates() throws {
        let url = makeStoreURL()
        defer { removeStore(at: url) }
        try seedV5Store(at: url)

        let context = ModelContext(try openMigratedStore(at: url))

        let ethiopia = try recipes(of: "Ethiopia", in: context)
        #expect(ethiopia.count == 3)
        #expect(ethiopia.contains { $0.grinder?.name == "K-Ultra" })
        #expect(ethiopia.contains { $0.brewer?.name == "Robot" && $0.grinder == nil })
        #expect(try recipes(of: "Kenya", in: context).count == 1)
    }

    @Test func migrationKeepsAllBrewsAndEquipment() throws {
        let url = makeStoreURL()
        defer { removeStore(at: url) }
        try seedV5Store(at: url)

        let context = ModelContext(try openMigratedStore(at: url))

        let brews = try context.fetch(FetchDescriptor<SchemaV6.Brew>())
        #expect(brews.count == 2)
        #expect(brews.allSatisfy { $0.recipe != nil && $0.coffee?.name == "Ethiopia" })
        #expect(try context.fetchCount(FetchDescriptor<SchemaV6.Equipment>()) == 3)
        #expect(try context.fetchCount(FetchDescriptor<SchemaV6.Coffee>()) == 2)
    }
}
