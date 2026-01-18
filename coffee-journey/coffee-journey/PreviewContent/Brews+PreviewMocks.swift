//
//  Brews+PreviewMocks.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 17.01.26.
//
import Foundation

#if DEBUG
extension Brew {
    struct Mock {
        // 10 brews in the last 5 days, two per day
        static let brews: [Brew] = [
            // Today
            Brew(
                date: DateHelper.daysAgo(0, hour: 14, minute: 30),
                amountCoffee: 20.0,
                grindSetting: 20.0,
                waterTemperature: 96.0,
                extractionTime: 180,
                taste: 5,
                output: 320.0,
                rating: .thumbsUp
            ),
            Brew(
                date: DateHelper.daysAgo(0, hour: 9, minute: 13),
                amountCoffee: 18.0,
                grindSetting: 5.0,
                waterTemperature: 93.0,
                extractionTime: 30,
                taste: 4,
                output: 36.0,
                rating: .thumbsUp
            ),
            // 1 day ago
            Brew(
                date: DateHelper.daysAgo(-1, hour: 8, minute: 33),
                amountCoffee: 20.0,
                grindSetting: 20.0,
                waterTemperature: 96.0,
                extractionTime: 180,
                taste: 2,
                output: 320.0,
                rating: .thumbsDown
            ),
            Brew(
                date: DateHelper.daysAgo(-1, hour: 16, minute: 44),
                amountCoffee: 18.0,
                grindSetting: 5.0,
                waterTemperature: 93.0,
                extractionTime: 30,
                taste: 1,
                output: 36.0,
                rating: .thumbsDown
            ),
            // 2 days ago
            Brew(
                date: DateHelper.daysAgo(-2, hour: 14, minute: 12),
                amountCoffee: 20.0,
                grindSetting: 20.0,
                waterTemperature: 96.0,
                extractionTime: 180,
                taste: 4,
                output: 320.0,
                rating: .thumbsUp
            ),
            Brew(
                date: DateHelper.daysAgo(-2, hour: 17, minute: 04),
                amountCoffee: 18.0,
                grindSetting: 5.0,
                waterTemperature: 93.0,
                extractionTime: 30,
                taste: 3,
                output: 36.0,
                rating: .thumbsUp
            ),
            // 3 days ago
            Brew(
                date: DateHelper.daysAgo(-3, hour: 12, minute: 56),
                amountCoffee: 20.0,
                grindSetting: 20.0,
                waterTemperature: 96.0,
                extractionTime: 180,
                taste: 3,
                output: 320.0,
                rating: .thumbsDown
            ),
            Brew(
                date: DateHelper.daysAgo(-3, hour: 15, minute: 28),
                amountCoffee: 18.0,
                grindSetting: 5.0,
                waterTemperature: 93.0,
                extractionTime: 30,
                taste: 3,
                output: 36.0,
                rating: .thumbsDown
            ),
            // 4 days ago
            Brew(
                date: DateHelper.daysAgo(-4, hour: 12, minute: 56),
                amountCoffee: 20.0,
                grindSetting: 20.0,
                waterTemperature: 96.0,
                extractionTime: 180,
                taste: 2,
                output: 320.0,
                rating: .thumbsUp
            ),
            Brew(
                date: DateHelper.daysAgo(-4, hour: 15, minute: 28),
                amountCoffee: 18.0,
                grindSetting: 5.0,
                waterTemperature: 93.0,
                extractionTime: 30,
                taste: 3,
                output: 36.0,
                rating: .thumbsUp
            )
        ]
    }
}
#endif
