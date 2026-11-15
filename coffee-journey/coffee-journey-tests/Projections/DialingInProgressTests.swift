//
//  DialingInProgressTests.swift
//  coffee-journey
//

import Foundation
import Testing
import SwiftData
@testable import coffee_journey


@MainActor
struct DialingInProgressTests {

    // Keeps the in-memory store alive for the duration of a test.
    private let context = ModelContext(ContainerFactory.createInMemory())
    private let start = Date(timeIntervalSince1970: 1_800_000_000)

    private func date(day: Double) -> Date {
        start.addingTimeInterval(day * 86_400)
    }

    private func makeBrew(day: Double, taste: Int = 3, clarity: Int? = 3, rating: BrewRating = .thumbsUp) -> Brew {
        let brew = Brew(date: date(day: day), beanAge: nil, amountCoffee: 18, grindSetting: 10, temperature: 94,
                        extractionTime: 30, taste: taste, output: 36, rating: rating, clarity: clarity)
        context.insert(brew)
        return brew
    }

    private func makeRefill(day: Double) -> Refill {
        let refill = Refill(amount: 250, roastDate: date(day: day - 7), date: date(day: day))
        context.insert(refill)
        return refill
    }

    @Test func sortsBrewsByDateAndNumbersFromOne() {
        let progress = DialingInProgress(brews: [
            makeBrew(day: 2, taste: 2),
            makeBrew(day: 0, taste: 1),
            makeBrew(day: 1, taste: 5)
        ], refills: [])

        #expect(progress.points.map(\.number) == [1, 2, 3])
        #expect(progress.points.map(\.taste) == [1, 5, 2])
        #expect(progress.points.map(\.date) == [date(day: 0), date(day: 1), date(day: 2)])
    }

    @Test func averagesOverAvailableBrewsWhenFewerThanThree() {
        let progress = DialingInProgress(brews: [
            makeBrew(day: 0, taste: 1, clarity: 2),
            makeBrew(day: 1, taste: 2, clarity: 5)
        ], refills: [])

        #expect(progress.points.map(\.tasteAverage) == [1, 1.5])
        #expect(progress.points.map(\.clarityAverage) == [2, 3.5])
    }

    @Test func averagesOverLastThreeBrews() {
        let progress = DialingInProgress(brews: [
            makeBrew(day: 0, taste: 1),
            makeBrew(day: 1, taste: 2),
            makeBrew(day: 2, taste: 3),
            makeBrew(day: 3, taste: 4)
        ], refills: [])

        #expect(progress.points.map(\.tasteAverage) == [1, 1.5, 2, 3])
    }

    @Test func brewsWithoutClarityStayInTasteButNotInClarity() {
        let progress = DialingInProgress(brews: [
            makeBrew(day: 0, taste: 1, clarity: 1),
            makeBrew(day: 1, taste: 4, clarity: nil),
            makeBrew(day: 2, taste: 4, clarity: 3)
        ], refills: [])

        #expect(progress.points.count == 3)
        #expect(progress.points.map(\.tasteAverage) == [1, 2.5, 3])
        #expect(progress.points.map(\.clarityAverage) == [1, nil, 2])
    }

    @Test func refillBetweenBrewsMarksTheNextBrew() {
        let brews = (0..<6).map { makeBrew(day: Double($0)) }
        let progress = DialingInProgress(brews: brews, refills: [makeRefill(day: 3.5)])

        #expect(progress.refillMarkers == [5])
    }

    @Test func refillsBeforeFirstOrAfterLastBrewAreNotMarked() {
        let brews = (1...3).map { makeBrew(day: Double($0)) }
        let progress = DialingInProgress(brews: brews, refills: [makeRefill(day: 0), makeRefill(day: 5)])

        #expect(progress.refillMarkers.isEmpty)
    }

    @Test func recipeWithoutBrewsIsEmpty() {
        let progress = DialingInProgress(brews: [], refills: [makeRefill(day: 0)])

        #expect(progress.points.isEmpty)
        #expect(progress.refillMarkers.isEmpty)
    }
}
