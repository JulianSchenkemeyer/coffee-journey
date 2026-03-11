//
//  CoffeeRepositoryTest.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 10.03.26.
//
import Foundation
import Testing
import SwiftData
@testable import coffee_journey


@MainActor
struct SwiftDataCoffeeRepositoryTests {

    // MARK: - Helpers

    private func prepareEnvironment() throws -> (SwiftDataCoffeeRepository, ModelContext) {
        let container = ContainerFactory.createInMemory()
        let context = ModelContext(container)
        let repository = SwiftDataCoffeeRepository(context: context)
        return (repository, context)
    }

    @discardableResult
    private func insertCoffee(
        name: String = "Ethiopia Yirgacheffe",
        roaster: String = "Blue Bottle",
        into context: ModelContext
    ) throws -> Coffee {
        let coffee = Coffee(
            name: name,
            roaster: roaster,
            roastCategory: "Light",
            amount: 250.0,
            amountLeft: 250.0,
            lastRefill: .now,
            brews: [],
            recipes: [],
            totalBrews: 0,
            brewsSinceRefill: 0,
            roastDate: .now,
            rating: 0.0,
            notes: ""
        )
        context.insert(coffee)
        try context.save()
        return coffee
    }

    // MARK: - Create

    @Test func createPersistsCoffee() throws {
        let (repository, context) = try prepareEnvironment()
        let coffee = Coffee(
            name: "Kenya AA",
            roaster: "Onyx",
            roastCategory: "Medium",
            amount: 200.0,
            amountLeft: 200.0,
            lastRefill: .now,
            brews: [],
            recipes: [],
            totalBrews: 0,
            brewsSinceRefill: 0,
            roastDate: .now,
            rating: 0.0,
            notes: ""
        )

        let created = try repository.create(coffee)

        let all = try context.fetch(FetchDescriptor<Coffee>())
        #expect(all.count == 1)
        #expect(created.name == "Kenya AA")
        #expect(created.roaster == "Onyx")
    }

    @Test func createReturnsTheSameCoffee() throws {
        let (repository, context) = try prepareEnvironment()
        let coffee = Coffee(
            name: "Kenya AA",
            roaster: "Onyx",
            roastCategory: "Medium",
            amount: 200.0,
            amountLeft: 200.0,
            lastRefill: .now,
            brews: [],
            recipes: [],
            totalBrews: 0,
            brewsSinceRefill: 0,
            roastDate: .now,
            rating: 0.0,
            notes: ""
        )

        let created = try repository.create(coffee)

        #expect(created.persistentModelID == coffee.persistentModelID)
    }

    // MARK: - FetchAll

    @Test func fetchAllReturnsAllCoffees() throws {
        let (repository, context) = try prepareEnvironment()
        try insertCoffee(name: "Coffee A", roaster: "Roaster A", into: context)
        try insertCoffee(name: "Coffee B", roaster: "Roaster B", into: context)

        let result = try repository.fetchAll()

        #expect(result.count == 2)
    }

    @Test func fetchAllReturnsEmptyWhenStoreIsEmpty() throws {
        let (repository, _) = try prepareEnvironment()

        let result = try repository.fetchAll()

        #expect(result.isEmpty)
    }

    // MARK: - Update

    @Test func updatePersistsChanges() throws {
        let (repository, context) = try prepareEnvironment()
        let coffee = try insertCoffee(into: context)

        coffee.name = "Updated Name"
        coffee.amountLeft = 100.0
        let updated = try repository.update(coffee)

        let fetched = context.model(for: coffee.persistentModelID) as? Coffee
        #expect(updated.name == "Updated Name")
        #expect(fetched?.name == "Updated Name")
        #expect(fetched?.amountLeft == 100.0)
    }

    @Test func updateReturnsTheSameCoffee() throws {
        let (repository, context) = try prepareEnvironment()
        let coffee = try insertCoffee(into: context)

        let result = try repository.update(coffee)

        #expect(result.persistentModelID == coffee.persistentModelID)
    }

    // MARK: - Delete

    @Test func deleteRemovesCoffeeFromStore() throws {
        let (repository, context) = try prepareEnvironment()
        let coffee = try insertCoffee(into: context)

        try repository.delete(coffee)

        let remaining = try context.fetch(FetchDescriptor<Coffee>())
        #expect(remaining.isEmpty)
    }

    @Test func deletingNonExistentCoffeeDoesNotThrow() throws {
        let (repository, context) = try prepareEnvironment()
        let coffee = try insertCoffee(into: context)
        context.delete(coffee)          // delete directly, without saving
        try context.save()

        // deleting an already-deleted model should not throw
        #expect(throws: Never.self) {
            try repository.delete(coffee)
        }
    }

    // MARK: - Exists

    @Test func existsReturnsTrueForDuplicateNameAndRoaster() throws {
        let (repository, context) = try prepareEnvironment()
        try insertCoffee(name: "Ethiopia Yirgacheffe", roaster: "Blue Bottle", into: context)

        let result = try repository.exists(name: "Ethiopia Yirgacheffe", roaster: "Blue Bottle", excluding: nil)

        #expect(result == true)
    }

    @Test func existsIsCaseInsensitive() throws {
        let (repository, context) = try prepareEnvironment()
        try insertCoffee(name: "Ethiopia Yirgacheffe", roaster: "Blue Bottle", into: context)

        let result = try repository.exists(name: "ethiopia yirgacheffe", roaster: "blue bottle", excluding: nil)

        #expect(result == true)
    }

    @Test func existsReturnsFalseWhenNoCoffeeMatches() throws {
        let (repository, context) = try prepareEnvironment()
        try insertCoffee(name: "Ethiopia Yirgacheffe", roaster: "Blue Bottle", into: context)

        let result = try repository.exists(name: "Kenya AA", roaster: "Onyx", excluding: nil)

        #expect(result == false)
    }

    @Test func existsReturnsFalseWhenOnlyNameMatches() throws {
        let (repository, context) = try prepareEnvironment()
        try insertCoffee(name: "Ethiopia Yirgacheffe", roaster: "Blue Bottle", into: context)

        let result = try repository.exists(name: "Ethiopia Yirgacheffe", roaster: "Onyx", excluding: nil)

        #expect(result == false)
    }

    @Test func existsExcludesSpecifiedCoffee() throws {
        let (repository, context) = try prepareEnvironment()
        let coffee = try insertCoffee(name: "Ethiopia Yirgacheffe", roaster: "Blue Bottle", into: context)

        // Same name/roaster but excluding the coffee itself (edit mode)
        let result = try repository.exists(name: "Ethiopia Yirgacheffe", roaster: "Blue Bottle", excluding: coffee)

        #expect(result == false)
    }

    @Test func existsIgnoresWhitespaceAroundNameAndRoaster() throws {
        let (repository, context) = try prepareEnvironment()
        try insertCoffee(name: "Ethiopia Yirgacheffe", roaster: "Blue Bottle", into: context)

        let result = try repository.exists(name: "  Ethiopia Yirgacheffe  ", roaster: "  Blue Bottle  ", excluding: nil)

        #expect(result == true)
    }
}
