//
//  PersistenceTransactionTests.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 01.06.26.
//
import Foundation
import Testing
import SwiftData
@testable import coffee_journey


@MainActor
struct SwiftDataPersistenceTransactionTests {

    // MARK: - Helpers

    private func prepareEnvironment() -> (
        SwiftDataPersistenceTransaction,
        SwiftDataCoffeeRepository,
        ModelContext
    ) {
        let container = ContainerFactory.createInMemory()
        let context = ModelContext(container)
        let persistenceContext = SwiftDataPersistenceContext(modelContext: context)
        let transaction = SwiftDataPersistenceTransaction(persistenceContext: persistenceContext)
        let repository = SwiftDataCoffeeRepository(persistenceContext: persistenceContext)
        return (transaction, repository, context)
    }

    private func makeCoffee(name: String = "Ethiopia") -> Coffee {
        Coffee(
            name: name,
            roaster: "Blue Bottle",
            roastCategory: "Light",
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

    private struct TransactionTestError: Error, Equatable {
        let code: Int
    }

    // MARK: - Success

    @Test func performCommitsOnSuccess() async throws {
        let (transaction, repository, context) = prepareEnvironment()
        let coffee = makeCoffee()

        try await transaction.perform {
            _ = try repository.create(coffee)
            coffee.notes = "updated inside transaction"
            _ = try repository.update(coffee)
        }

        let stored = try context.fetch(FetchDescriptor<Coffee>())
        #expect(stored.count == 1)
        #expect(stored.first?.notes == "updated inside transaction")
    }

    @Test func performReturnsValueFromBlock() async throws {
        let (transaction, _, _) = prepareEnvironment()

        let result = try await transaction.perform { 42 }

        #expect(result == 42)
    }

    // MARK: - Failure

    @Test func performRollsBackOnInnerThrow() async throws {
        let (transaction, repository, context) = prepareEnvironment()
        let coffee = makeCoffee()

        await #expect(throws: TransactionTestError.self) {
            try await transaction.perform {
                _ = try repository.create(coffee)
                throw TransactionTestError(code: 1)
            }
        }

        let stored = try context.fetch(FetchDescriptor<Coffee>())
        #expect(stored.isEmpty, "create inside the transaction must be rolled back")
    }

    @Test func performRethrowsOriginalError() async {
        let (transaction, _, _) = prepareEnvironment()

        await #expect(throws: TransactionTestError(code: 7)) {
            try await transaction.perform {
                throw TransactionTestError(code: 7)
            }
        }
    }

    // MARK: - Re-entrancy

    @Test func nestedPerformDefersCommitToOuter() async throws {
        let (transaction, repository, context) = prepareEnvironment()
        let coffeeA = makeCoffee(name: "Coffee A")
        let coffeeB = makeCoffee(name: "Coffee B")

        // Inner perform should not commit on its own; the outer throw should
        // roll back both inserts.
        await #expect(throws: TransactionTestError.self) {
            try await transaction.perform {
                _ = try repository.create(coffeeA)
                try await transaction.perform {
                    _ = try repository.create(coffeeB)
                }
                throw TransactionTestError(code: 2)
            }
        }

        let stored = try context.fetch(FetchDescriptor<Coffee>())
        #expect(stored.isEmpty, "inner perform should not commit independently of the outer")
    }

    @Test func nestedPerformCommitsBothOnOuterSuccess() async throws {
        let (transaction, repository, context) = prepareEnvironment()
        let coffeeA = makeCoffee(name: "Coffee A")
        let coffeeB = makeCoffee(name: "Coffee B")

        try await transaction.perform {
            _ = try repository.create(coffeeA)
            try await transaction.perform {
                _ = try repository.create(coffeeB)
            }
        }

        let stored = try context.fetch(FetchDescriptor<Coffee>())
        #expect(stored.count == 2)
    }

    // MARK: - Save deferral baseline

    @Test func repositoryCreateOutsideTransactionSavesEagerly() throws {
        let (_, repository, context) = prepareEnvironment()
        let coffee = makeCoffee()

        _ = try repository.create(coffee)

        let stored = try context.fetch(FetchDescriptor<Coffee>())
        #expect(stored.count == 1, "outside a transaction, create must save immediately")
    }
}
