//
//  BrewRepositoryTest.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 08.03.26.
//
import Foundation
import Testing
import SwiftData
@testable import coffee_journey


@MainActor
struct SwiftDataBrewRepositoryTest {

    // MARK: - Helpers

    private func prepareEnvironment() throws -> (SwiftDataBrewRepository, ModelContext) {
        let container = ContainerFactory.createInMemory()
        let context = ModelContext(container)
        let repository = SwiftDataBrewRepository(context: context)
        return (repository, context)
    }

    private func insertBrew(into context: ModelContext) throws -> Brew {
        let brew = Brew(
            date: .now,
            amountCoffee: 18.0,
            grindSetting: 9.0,
            temperature: 96,
            extractionTime: 30,
            taste: BrewTaste.balanced.rawValue,
            output: 33.0,
            rating: .thumbsDown
        )
        context.insert(brew)
        try context.save()
        return brew
    }

    // MARK: - Update

    @Test func updatePersistsChanges() throws {
        let (repository, context) = try prepareEnvironment()
        let brew = try insertBrew(into: context)

        brew.amountCoffee = 20.0
        brew.taste = BrewTaste.bitter.rawValue
        let updated = try repository.update(brew)

        let fetched = context.model(for: brew.persistentModelID) as? Brew
        #expect(updated.amountCoffee == 20.0)
        #expect(fetched?.amountCoffee == 20.0)
        #expect(fetched?.taste == BrewTaste.bitter.rawValue)
    }

    @Test func updateReturnsTheSameBrew() throws {
        let (repository, context) = try prepareEnvironment()
        let brew = try insertBrew(into: context)

        let result = try repository.update(brew)

        #expect(result.persistentModelID == brew.persistentModelID)
    }

    // MARK: - Delete

    @Test func deleteRemovesBrewFromStore() throws {
        let (repository, context) = try prepareEnvironment()
        let brew = try insertBrew(into: context)

        try repository.delete(brew)

        let remaining = try context.fetch(FetchDescriptor<Brew>())
        #expect(remaining.isEmpty)
    }

    @Test func deletingNonExistentBrewDoesNotThrow() throws {
        let (repository, context) = try prepareEnvironment()
        let brew = try insertBrew(into: context)
        context.delete(brew)          // delete directly, without saving
        try context.save()

        // deleting an already-deleted model should not throw
        #expect(throws: Never.self) {
            try repository.delete(brew)
        }
    }
}
