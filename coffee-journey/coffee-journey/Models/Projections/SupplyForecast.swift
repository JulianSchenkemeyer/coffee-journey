//
//  SupplyForecast.swift
//  coffee-journey
//

import Foundation


// Recent consumption rate and how long the remaining beans last at that rate.
struct SupplyForecast {
    static let window: TimeInterval = 14 * 24 * 60 * 60
    static let minimumBrews = 3

    let gramsPerDay: Double
    let daysLeft: Double

    init?(brews: [Brew], amountLeft: Double, now: Date = .now) {
        guard amountLeft > 0 else { return nil }

        let recent = brews.filter { $0.date > now.addingTimeInterval(-Self.window) && $0.date <= now }
        guard recent.count >= Self.minimumBrews,
              let firstBrew = brews.map(\.date).min() else { return nil }

        // Divide by the days actually covered, so a coffee first brewed 3 days ago isn't averaged over 14.
        let coveredDays = Swift.max(Swift.min(now.timeIntervalSince(firstBrew), Self.window) / (24 * 60 * 60), 1)
        let gramsPerDay = recent.map(\.amountCoffee).reduce(0, +) / coveredDays
        guard gramsPerDay > 0 else { return nil }

        self.gramsPerDay = gramsPerDay
        self.daysLeft = amountLeft / gramsPerDay
    }
}
