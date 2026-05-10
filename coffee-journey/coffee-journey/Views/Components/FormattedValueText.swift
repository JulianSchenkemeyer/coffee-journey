//
//  FormattedValueText.swift
//  coffee-journey
//

import SwiftUI


struct FormattedValueText<V: Equatable, F: FormatStyle>: View where F.FormatInput == V, F.FormatOutput == String {
    let min: V
    let max: V
    let format: F
    var unit: String?

    init(value: V, format: F, unit: String? = nil) {
        self.min = value
        self.max = value
        self.format = format
        self.unit = unit
    }

    init(min: V, max: V, format: F, unit: String? = nil) {
        self.min = min
        self.max = max
        self.format = format
        self.unit = unit
    }

    var body: some View {
        if min == max {
            Text(formattedValue(min))
        } else {
            Text("\(formattedValue(min)) ... \(formattedValue(max))")
        }
    }

    private func formattedValue(_ value: V) -> String {
        let formatted = format.format(value)
        if let unit {
            return "\(formatted) \(unit)"
        }
        return formatted
    }
}
