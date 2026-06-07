//
//  CoffeeConstants.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 24.02.26.
//

enum CoffeeConstants {
    enum Amount {
        static let range: ClosedRange<Double> = 0.0...2000.0
        static let step: Double = 5.0
        static let defaultValue: Double = 250.0
        static let lowThreshold: Double = 50.0
    }

    enum Rating {
        static let range: ClosedRange<Double> = 0.0...5.0
        static let step: Double = 0.5
        static let defaultValue: Double = 3.0
    }
}
