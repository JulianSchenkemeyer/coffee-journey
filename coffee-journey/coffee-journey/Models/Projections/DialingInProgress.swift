//
//  DialingInProgress.swift
//  coffee-journey
//

import Foundation

// A recipe's brews in date order, numbered from 1, with a rolling trend over
// the last 3 brews and the brews that came first after a refill.
struct DialingInProgress {
    struct Point: Identifiable {
        let number: Int
        let date: Date
        let taste: Int
        let clarity: Int?
        let rating: BrewRating
        let tasteAverage: Double
        // Averaged over brews that have a clarity only; nil when this brew has none.
        let clarityAverage: Double?

        var id: Int { number }
    }

    let points: [Point]
    // Brew numbers that are the first brew after a refill. Never brew 1:
    // a refill before any brew has nothing to mark a change against.
    let refillMarkers: [Int]

    init(brews: [Brew], refills: [Refill]) {
        let sorted = brews.sorted { $0.date < $1.date }

        var tastes: [Int] = []
        var clarities: [Int] = []
        points = sorted.enumerated().map { index, brew in
            tastes.append(brew.taste)
            var clarityAverage: Double?
            if let clarity = brew.clarity {
                clarities.append(clarity)
                clarityAverage = Self.trailingAverage(clarities)
            }
            return Point(
                number: index + 1,
                date: brew.date,
                taste: brew.taste,
                clarity: brew.clarity,
                rating: brew.rating,
                tasteAverage: Self.trailingAverage(tastes),
                clarityAverage: clarityAverage
            )
        }

        refillMarkers = sorted.indices.dropFirst().filter { index in
            refills.contains { sorted[index - 1].date < $0.date && $0.date <= sorted[index].date }
        }.map { $0 + 1 }
    }

    // Mean of the last 3 values, or of all of them while there are fewer.
    private static func trailingAverage(_ values: [Int]) -> Double {
        let recent = values.suffix(3)
        return Double(recent.reduce(0, +)) / Double(recent.count)
    }
}
