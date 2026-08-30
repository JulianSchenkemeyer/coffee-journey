//
//  BrewRatingFormView.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 19.06.26.
//

import SwiftUI
import SwiftData


struct BrewRatingFormView: View {
    @ScaledMetric private var sliderLabelWidth: CGFloat = 55

    let recipe: Recipe
    let usedCoffee: Double
    let grindSetting: Double
    let temperature: Int
    let extractionTime: Int
    let output: Double

    @Binding var taste: Double
    @Binding var clarity: Double

    private var ratio: Double? {
        guard usedCoffee > 0 else { return nil }
        return output / usedCoffee
    }

    private var flowRate: Double? {
        guard extractionTime > 0 else { return nil }
        return output / Double(extractionTime)
    }

    private var brewParameters: [(icon: String, label: String, value: String)] {
        [
            ("scalemass.fill", "Coffee", "\(usedCoffee.formatted(.number.precision(.fractionLength(1)))) \(RecipeConstants.Beans.unit)"),
            ("dial.high.fill", "Grind", grindSetting.formatted(.number.precision(.fractionLength(0)))),
            ("thermometer.medium", "Temp", "\(temperature) \(RecipeConstants.Temperature.unit)"),
            ("timer", "Time", "\(extractionTime) \(RecipeConstants.ExtractionTime.unit)"),
            ("drop.fill", "Output", "\(output.formatted(.number.precision(.fractionLength(1)))) \(RecipeConstants.Output.unit)")
        ]
    }

    private var brewMetrics: [(icon: String, label: String, value: String)] {
        [
            ("divide", "Ratio", ratio.map { "1:\($0.formatted(.number.precision(.fractionLength(1)))) \(RecipeConstants.Ratio.unit)" } ?? "–"),
            ("waveform.path", "Flow Rate", flowRate.map { "\($0.formatted(.number.precision(.fractionLength(1)))) \(RecipeConstants.FlowRate.unit)" } ?? "–")
        ]
    }

    private let gridColumns = [GridItem(.flexible(), alignment: .leading), GridItem(.flexible(), alignment: .leading)]

    var body: some View {
        Form {
            Section("Summary") {
                VStack(alignment: .leading, spacing: 8) {
                    LazyVGrid(columns: gridColumns, alignment: .leading, spacing: 8) {
                        ForEach(brewParameters, id: \.label) { row in
                            parameter(row.icon, row.label, row.value)
                        }
                    }

                    Divider()

                    LazyVGrid(columns: gridColumns, alignment: .leading, spacing: 8) {
                        ForEach(brewMetrics, id: \.label) { row in
                            parameter(row.icon, row.label, row.value)
                        }
                    }
                }
                .font(.subheadline)
            }

            Section("Rating") {
                Slider(value: $taste, in: RecipeConstants.Taste.range, step: RecipeConstants.Taste.step) {
                    Text("Taste")
                } minimumValueLabel: {
                    Text("Sour").frame(width: sliderLabelWidth, alignment: .leading)
                } maximumValueLabel: {
                    Text("Bitter").frame(width: sliderLabelWidth, alignment: .trailing)
                }

                Slider(value: $clarity, in: RecipeConstants.Clarity.range, step: RecipeConstants.Clarity.step) {
                    Text("Clarity")
                } minimumValueLabel: {
                    Text("Flat").frame(width: sliderLabelWidth, alignment: .leading)
                } maximumValueLabel: {
                    Text("Harsh").frame(width: sliderLabelWidth, alignment: .trailing)
                }
            }
        }
    }

    private func parameter(_ systemImage: String, _ label: String, _ value: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: systemImage)
                .frame(width: 20)
            Text("\(label):")
                .fontWeight(.medium)
            Text(value)
                .foregroundStyle(.secondary)
        }
    }
}


#Preview(traits: .modifier(SampleDataModifier())) {
    @Previewable @Query var coffees: [Coffee]
    @Previewable @State var taste = RecipeConstants.Taste.defaultValue
    @Previewable @State var clarity = RecipeConstants.Clarity.defaultValue

    if let coffee = coffees.first, let recipe = coffee.recipes.first {
        BrewRatingFormView(
            recipe: recipe,
            usedCoffee: 18.0,
            grindSetting: 12.0,
            temperature: 96,
            extractionTime: 30,
            output: 36.0,
            taste: $taste,
            clarity: $clarity
        )
    }
}
