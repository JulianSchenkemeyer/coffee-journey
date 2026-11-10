//
//  RestCurveTests.swift
//  coffee-journey
//

import Foundation
import Testing
import SwiftData
@testable import coffee_journey


@MainActor
struct RestCurveTests {

    // Keeps the in-memory store alive for the duration of a test.
    private let context = ModelContext(ContainerFactory.createInMemory())

    private func makeBrew(beanAge: Int?, rating: BrewRating = .thumbsUp) -> Brew {
        let brew = Brew(date: .now, beanAge: beanAge, amountCoffee: 18, grindSetting: 10, temperature: 94,
                        extractionTime: 30, taste: 3, output: 36, rating: rating)
        context.insert(brew)
        return brew
    }

    @Test func bucketsSplitAtWeekBoundaries() {
        let curve = RestCurve(brews: [0, 7, 8, 14, 15].map { makeBrew(beanAge: $0) })

        #expect(curve.buckets.map(\.total) == [2, 2, 1])
        #expect(curve.buckets.map(\.firstDay) == [0, 8, 15])
        #expect(curve.buckets.map(\.lastDay) == [7, 14, 21])
    }

    @Test func countsGoodAndBadBrewsSeparately() {
        let curve = RestCurve(brews: [
            makeBrew(beanAge: 3, rating: .thumbsUp),
            makeBrew(beanAge: 4, rating: .thumbsDown),
            makeBrew(beanAge: 5, rating: .thumbsUp)
        ])

        #expect(curve.buckets.first?.good == 2)
        #expect(curve.buckets.first?.bad == 1)
    }

    @Test func keepsEmptyWeeksBetweenBrews() {
        let curve = RestCurve(brews: [makeBrew(beanAge: 2), makeBrew(beanAge: 20)])

        #expect(curve.buckets.map(\.total) == [1, 0, 1])
    }

    @Test func leavesOutBrewsWithoutBeanAge() {
        let curve = RestCurve(brews: [makeBrew(beanAge: nil), makeBrew(beanAge: 10)])

        #expect(curve.brewCount == 1)
        #expect(curve.buckets.map(\.total) == [0, 1])
    }

    @Test func coffeeWithoutBrewsHasNoBuckets() {
        let curve = RestCurve(brews: [])

        #expect(curve.buckets.isEmpty)
        #expect(curve.brewCount == 0)
    }
}
