//
//  RecipeConstants.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 24.02.26.
//

enum RecipeConstants {
    enum Beans {
        static let range: ClosedRange<Double> = 0.0...50.0
        static let step: Double = 0.1
        static let defaultValue: Double = 18.0
        static let unit = "g"
    }

    enum GrindSetting {
        static let range: ClosedRange<Double> = 0.0...50.0
        static let step: Double = 1.0
        static let defaultValue: Double = 12.0
    }

    enum Temperature {
        static let range: ClosedRange<Int> = 80...100
        static let step: Int = 1
        static let defaultValue: Int = 96
        static let unit = "°C"
    }

    enum ExtractionTime {
        static let range: ClosedRange<Int> = 0...180
        static let step: Int = 1
        static let defaultValue: Int = 30
        static let unit = "s"
    }

    enum Output {
        static let range: ClosedRange<Double> = 0.0...100.0
        static let step: Double = 0.1
        static let defaultValue: Double = 36.0
        static let unit = "g"
    }

    enum Taste {
        static let range: ClosedRange<Double> = 1.0...5.0
        static let step: Double = 1
        static let defaultValue: Double = 3
    }

    enum Clarity {
        static let range: ClosedRange<Double> = 1.0...5.0
        static let step: Double = 1
        static let defaultValue: Double = 3
    }
}
