//
//  SupplyForecastTests.swift
//  coffee-journey
//

import Foundation
import Testing
import SwiftData
@testable import coffee_journey


@MainActor
struct SupplyForecastTests {

    // Keeps the in-memory store alive for the duration of a test.
    private let context = ModelContext(ContainerFactory.createInMemory())
    private let now = Date(timeIntervalSince1970: 1_800_000_000)

    private func makeBrew(daysAgo: Double, amount: Double = 18) -> Brew {
        let brew = Brew(date: now.addingTimeInterval(-daysAgo * 24 * 60 * 60), beanAge: nil, amountCoffee: amount,
                        grindSetting: 10, temperature: 94, extractionTime: 30, taste: 3, output: 36, rating: .thumbsUp)
        context.insert(brew)
        return brew
    }

    @Test func averagesRecentBrewsOverTheWindow() throws {
        // 14 brews of 18 g, one per day over the last two weeks, with older history before them.
        let brews = (0..<14).map { makeBrew(daysAgo: Double($0)) } + [makeBrew(daysAgo: 30)]

        let forecast = try #require(SupplyForecast(brews: brews, amountLeft: 180, now: now))

        #expect(forecast.gramsPerDay == 18)
        #expect(forecast.daysLeft == 10)
    }

    @Test func averagesOverCoveredDaysForANewCoffee() throws {
        let brews = [makeBrew(daysAgo: 3), makeBrew(daysAgo: 2), makeBrew(daysAgo: 1)]

        let forecast = try #require(SupplyForecast(brews: brews, amountLeft: 90, now: now))

        #expect(forecast.gramsPerDay == 18)
        #expect(forecast.daysLeft == 5)
    }

    @Test func returnsNilWithTooFewBrews() {
        let brews = [makeBrew(daysAgo: 1), makeBrew(daysAgo: 2)]

        #expect(SupplyForecast(brews: brews, amountLeft: 200, now: now) == nil)
    }

    @Test func ignoresBrewsOutsideTheWindow() {
        // Plenty of brews, but only two of them in the last 14 days.
        let brews = [makeBrew(daysAgo: 1), makeBrew(daysAgo: 5)] + (20..<30).map { makeBrew(daysAgo: Double($0)) }

        #expect(SupplyForecast(brews: brews, amountLeft: 200, now: now) == nil)
    }

    @Test func returnsNilForAnEmptyCoffee() {
        let brews = (0..<5).map { makeBrew(daysAgo: Double($0)) }

        #expect(SupplyForecast(brews: brews, amountLeft: 0, now: now) == nil)
    }
}
