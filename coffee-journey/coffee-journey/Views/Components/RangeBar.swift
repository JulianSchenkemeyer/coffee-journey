//
//  RangeBar.swift
//  coffee-journey
//

import SwiftUI


// A recipe parameter's min…max range and target, as text and as a bar.
struct RangeBar<F: FormatStyle>: View where F.FormatInput == Double, F.FormatOutput == String {
    let label: LocalizedStringKey
    let symbol: String
    let bounds: ClosedRange<Double>
    let min: Double
    let max: Double
    let target: Double
    let format: F
    var unit: String?

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    private var isCalibrated: Bool { min == max }

    // Zoomed around the recipe so narrow ranges stay visible, but never past `bounds`.
    private var visibleRange: ClosedRange<Double> {
        let padding = Swift.max(max - min, (bounds.upperBound - bounds.lowerBound) * 0.05)
        return Swift.max(bounds.lowerBound, min - padding)...Swift.min(bounds.upperBound, max + padding)
    }

    var body: some View {
        if dynamicTypeSize.isAccessibilitySize {
            // Not a GridRow, so it spans the whole Grid width.
            VStack(alignment: .leading, spacing: 6) {
                Label(label, systemImage: symbol)
                    .accessibilityHidden(true)
                Text(valueText)
                    .monospacedDigit()
                    .foregroundStyle(.secondary)
                    .accessibilityHidden(true)
                RangeBarTrack(min: fraction(of: min), max: fraction(of: max), target: fraction(of: target))
                    .accessibilityElement()
                    .accessibilityLabel(label)
                    .accessibilityValue(accessibilityValue)
            }
        } else {
            // VoiceOver reads the whole row from the track; label and value cells are hidden.
            GridRow {
                Label(label, systemImage: symbol)
                    .accessibilityHidden(true)
                RangeBarTrack(min: fraction(of: min), max: fraction(of: max), target: fraction(of: target))
                    .accessibilityElement()
                    .accessibilityLabel(label)
                    .accessibilityValue(accessibilityValue)
                Text(valueText)
                    .monospacedDigit()
                    .fixedSize()
                    .foregroundStyle(.secondary)
                    .accessibilityHidden(true)
                    .gridColumnAlignment(.trailing)
            }
        }
    }

    // "18.2–18.6 g", or "18.4 g" once calibrated
    private var valueText: String {
        let text = isCalibrated ? format.format(target) : "\(format.format(min))–\(format.format(max))"
        guard let unit else { return text }
        return "\(text)\u{00A0}\(unit)"
    }

    private var accessibilityValue: String {
        if isCalibrated {
            return formatted(target)
        }
        return String(localized: "\(formatted(min)) to \(formatted(max)), target \(formatted(target))")
    }

    private func formatted(_ value: Double) -> String {
        let text = format.format(value)
        guard let unit else { return text }
        return "\(text) \(unit)"
    }

    // Where `value` sits in `visibleRange`, from 0 to 1.
    private func fraction(of value: Double) -> Double {
        let range = visibleRange
        let span = range.upperBound - range.lowerBound
        guard span > 0 else { return 0.5 }
        let clamped = Swift.min(Swift.max(value, range.lowerBound), range.upperBound)
        return (clamped - range.lowerBound) / span
    }
}


// Track, min…max band and target dot. Positions are fractions of the track width.
private struct RangeBarTrack: View {
    let min: Double
    let max: Double
    let target: Double

    @ScaledMetric private var dotSize: CGFloat = 12

    var body: some View {
        Canvas { context, size in
            let trackHeight = dotSize / 2
            let trackWidth = size.width - dotSize
            let trackY = (size.height - trackHeight) / 2
            // Inset by half a dot so the dot stays inside the canvas at either end.
            let x = { (fraction: Double) in dotSize / 2 + trackWidth * fraction }

            let track = CGRect(x: x(0), y: trackY, width: trackWidth, height: trackHeight)
            context.fill(Capsule().path(in: track), with: .style(.quaternary))

            if min != max {
                let band = CGRect(x: x(min), y: trackY, width: x(max) - x(min), height: trackHeight)
                context.fill(Capsule().path(in: band), with: .color(.accentColor.opacity(0.4)))
            }

            let dot = CGRect(x: x(target) - dotSize / 2, y: (size.height - dotSize) / 2, width: dotSize, height: dotSize)
            context.fill(Circle().path(in: dot), with: .color(.accentColor))
        }
        .frame(minWidth: 60)
        .frame(height: dotSize)
    }
}


#Preview(traits: .modifier(SampleDataModifier())) {
    let oneDecimal = FloatingPointFormatStyle<Double>.number.precision(.fractionLength(1))
    let whole = FloatingPointFormatStyle<Double>.number.precision(.fractionLength(0))

    @MainActor @ViewBuilder func rangeBars(for recipe: Recipe) -> some View {
        Grid(alignment: .leading, horizontalSpacing: 12, verticalSpacing: 10) {
            RangeBar(label: "Beans", symbol: CJSymbol.BrewParameter.coffee, bounds: RecipeConstants.Beans.range,
                     min: recipe.minAmountBeans, max: recipe.maxAmountBeans, target: recipe.amountBeans,
                     format: oneDecimal, unit: RecipeConstants.Beans.unit)
            RangeBar(label: "Grind", symbol: CJSymbol.BrewParameter.grind, bounds: RecipeConstants.GrindSetting.range,
                     min: recipe.minGrindSetting, max: recipe.maxGrindSetting, target: recipe.grindSetting,
                     format: .number.precision(.fractionLength(recipe.grindFractionDigits)))
            RangeBar(label: "Temp", symbol: CJSymbol.BrewParameter.temperature,
                     bounds: Double(RecipeConstants.Temperature.range.lowerBound)...Double(RecipeConstants.Temperature.range.upperBound),
                     min: Double(recipe.minTemperature), max: Double(recipe.maxTemperature), target: Double(recipe.temperature),
                     format: whole, unit: RecipeConstants.Temperature.unit)
            RangeBar(label: "Time", symbol: CJSymbol.BrewParameter.time,
                     bounds: Double(RecipeConstants.ExtractionTime.range.lowerBound)...Double(RecipeConstants.ExtractionTime.range.upperBound),
                     min: Double(recipe.minExtractionTime), max: Double(recipe.maxExtractionTime), target: Double(recipe.extractionTime),
                     format: whole, unit: RecipeConstants.ExtractionTime.unit)
            RangeBar(label: "Output", symbol: CJSymbol.BrewParameter.output, bounds: RecipeConstants.Output.range,
                     min: recipe.minOutput, max: recipe.maxOutput, target: recipe.output,
                     format: oneDecimal, unit: RecipeConstants.Output.unit)
        }
    }

    return Form {
        Section("Dialing In") {
            rangeBars(for: .Mock.espressoUsed)
        }
        Section("Calibrated") {
            rangeBars(for: .Mock.espresso)
        }
    }
}
