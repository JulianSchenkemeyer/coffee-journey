//
//  CoffeeUseCasesTests.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 11.03.26.
//
import Foundation
import Testing
import SwiftData
@testable import coffee_journey


@MainActor
struct CoffeeUseCasesTests {

    // MARK: - Helpers

    private func prepareEnvironment() throws -> (SwiftDataCoffeeRepository, ModelContext) {
        let container = ContainerFactory.createInMemory()
        let context = ModelContext(container)
        let persistenceContext = SwiftDataPersistenceContext(modelContext: context)
        let repository = SwiftDataCoffeeRepository(persistenceContext: persistenceContext)
        return (repository, context)
    }

    @discardableResult
    private func makeCoffee(name: String = "Ethiopia", amountLeft: Double = 250.0, into context: ModelContext) -> Coffee {
        let coffee = Coffee(
            name: name,
            roaster: "Blue Bottle",
            roastCategory: RoastCategory.light.rawValue,
            amount: amountLeft,
            amountLeft: amountLeft,
            lastRefill: .now,
            brews: [],
            recipes: [],
            totalBrews: 0,
            brewsSinceRefill: 3,
            roastDate: .now,
            rating: 0.0,
            notes: ""
        )
        context.insert(coffee)
        return coffee
    }

    private func makeCreateRequest(name: String = "Kenya AA", roaster: String = "Onyx") -> CreateCoffeeRequest {
        CreateCoffeeRequest(
            name: name,
            roaster: roaster,
            roastCategory: .medium,
            amount: 200.0,
            roastDate: .now,
            rating: 0.0,
            notes: ""
        )
    }

    // MARK: - CreateCoffee

    @Test func createCoffeePersistsCoffee() throws {
        let (repository, context) = try prepareEnvironment()
        let useCase = CreateCoffee(repository: repository)

        try useCase(request: makeCreateRequest())

        let all = try context.fetch(FetchDescriptor<Coffee>())
        #expect(all.count == 1)
    }

    @Test func createCoffeeMapsRequestFields() throws {
        let (repository, _) = try prepareEnvironment()
        let useCase = CreateCoffee(repository: repository)
        let request = makeCreateRequest(name: "Kenya AA", roaster: "Onyx")

        let created = try useCase(request: request)

        #expect(created.name == "Kenya AA")
        #expect(created.roaster == "Onyx")
        #expect(created.roastCategory == RoastCategory.medium.rawValue)
        #expect(created.amountLeft == 200.0)
        #expect(created.totalBrews == 0)
        #expect(created.brewsSinceRefill == 0)
    }

    @Test func createCoffeeReturnsCreatedCoffee() throws {
        let (repository, _) = try prepareEnvironment()
        let useCase = CreateCoffee(repository: repository)

        let created = try useCase(request: makeCreateRequest())

        #expect(created.name == "Kenya AA")
    }

    // MARK: - UpdateCoffee

    @Test func updateCoffeeAppliesRequestFields() throws {
        let (repository, context) = try prepareEnvironment()
        let useCase = UpdateCoffee(repository: repository)
        let coffee = makeCoffee(name: "Old Name", into: context)
        let request = UpdateCoffeeRequest(
            name: "New Name",
            roaster: "New Roaster",
            roastCategory: .dark,
            rating: 4.5,
            notes: "Updated notes"
        )

        try useCase(coffee: coffee, request: request)

        #expect(coffee.name == "New Name")
        #expect(coffee.roaster == "New Roaster")
        #expect(coffee.roastCategory == RoastCategory.dark.rawValue)
        #expect(coffee.rating == 4.5)
        #expect(coffee.notes == "Updated notes")
    }

    @Test func updateCoffeeReturnsSameCoffee() throws {
        let (repository, context) = try prepareEnvironment()
        let useCase = UpdateCoffee(repository: repository)
        let coffee = makeCoffee(into: context)
        let request = UpdateCoffeeRequest(
            name: "Updated",
            roaster: "Updated",
            roastCategory: .light,
            rating: 0.0,
            notes: ""
        )

        let result = try useCase(coffee: coffee, request: request)

        #expect(result.persistentModelID == coffee.persistentModelID)
    }

    // MARK: - DeleteCoffee

    @Test func deleteCoffeeRemovesFromStore() throws {
        let (repository, context) = try prepareEnvironment()
        let useCase = DeleteCoffee(repository: repository)
        let coffee = makeCoffee(into: context)
        try context.save()

        try useCase(coffee: coffee)

        let remaining = try context.fetch(FetchDescriptor<Coffee>())
        #expect(remaining.isEmpty)
    }

    // MARK: - CheckCoffeeExists

    @Test func checkExistsReturnsTrueForDuplicate() throws {
        let (repository, context) = try prepareEnvironment()
        let useCase = CheckCoffeeExists(repository: repository)
        makeCoffee(name: "Ethiopia", into: context)
        try context.save()

        let result = try useCase(name: "Ethiopia", roaster: "Blue Bottle", excluding: nil)

        #expect(result == true)
    }

    @Test func checkExistsReturnsFalseWhenNoCoffeeMatches() throws {
        let (repository, context) = try prepareEnvironment()
        let useCase = CheckCoffeeExists(repository: repository)
        makeCoffee(name: "Ethiopia", into: context)
        try context.save()

        let result = try useCase(name: "Kenya AA", roaster: "Onyx", excluding: nil)

        #expect(result == false)
    }

    @Test func checkExistsReturnsFalseWhenExcludingSelf() throws {
        let (repository, context) = try prepareEnvironment()
        let useCase = CheckCoffeeExists(repository: repository)
        let coffee = makeCoffee(name: "Ethiopia", into: context)
        try context.save()

        let result = try useCase(name: "Ethiopia", roaster: "Blue Bottle", excluding: coffee)

        #expect(result == false)
    }

    // MARK: - RefillBeans

    @Test func refillBeansAccumulatesAmount() throws {
        let (repository, context) = try prepareEnvironment()
        let useCase = RefillBeans(repository: repository)
        let coffee = makeCoffee(amountLeft: 50.0, into: context)
        let refill = Refill(amount: 200.0, roastDate: .now, date: .now)

        try useCase(coffee: coffee, refill: refill, dumpRest: false)

        #expect(coffee.amountLeft == 250.0)
    }

    @Test func refillBeansWithDumpRestReplacesAmount() throws {
        let (repository, context) = try prepareEnvironment()
        let useCase = RefillBeans(repository: repository)
        let coffee = makeCoffee(amountLeft: 50.0, into: context)
        let refill = Refill(amount: 200.0, roastDate: .now, date: .now)

        try useCase(coffee: coffee, refill: refill, dumpRest: true)

        #expect(coffee.amountLeft == 200.0)
    }

    @Test func refillBeansResetsBrewsSinceRefill() throws {
        let (repository, context) = try prepareEnvironment()
        let useCase = RefillBeans(repository: repository)
        let coffee = makeCoffee(into: context)   // starts with brewsSinceRefill = 3
        let refill = Refill(amount: 200.0, roastDate: .now, date: .now)

        try useCase(coffee: coffee, refill: refill)

        #expect(coffee.brewsSinceRefill == 0)
    }

    @Test func refillBeansAppendsRefillToHistory() throws {
        let (repository, context) = try prepareEnvironment()
        let useCase = RefillBeans(repository: repository)
        let coffee = makeCoffee(into: context)
        let refill = Refill(amount: 200.0, roastDate: .now, date: .now)

        try useCase(coffee: coffee, refill: refill)

        // coffee already has one refill from its init, so we expect 2 total
        #expect(coffee.refills.count == 2)
    }

    @Test func refillBeansReturnsCoffee() throws {
        let (repository, context) = try prepareEnvironment()
        let useCase = RefillBeans(repository: repository)
        let coffee = makeCoffee(into: context)
        let refill = Refill(amount: 200.0, roastDate: .now, date: .now)

        let result = try useCase(coffee: coffee, refill: refill)

        #expect(result.persistentModelID == coffee.persistentModelID)
    }
    
    // MARK: EmptyBeans
    
    @Test func emptyBeansEmptiesBeans() throws {
        let (repository, context) = try prepareEnvironment()
        let emptyBeans = EmptyBeans(repository: repository)
        let coffee = makeCoffee(amountLeft: 250, into: context)
        
        try emptyBeans(coffee: coffee)
        
        #expect(coffee.amountLeft == 0.0)
        #expect(coffee.amount == 250.0)
    }
    
    @Test func emptyBeansDoesNotAddRefill() throws {
        let (repository, context) = try prepareEnvironment()
        let emptyBeans = EmptyBeans(repository: repository)
        let coffee = makeCoffee(amountLeft: 250, into: context)
        
        #expect(coffee.refills.count == 1)
        
        try emptyBeans(coffee: coffee)
        
        #expect(coffee.refills.count == 1)
    }
}
