//
//  RecipeRow.swift
//  coffee-journey
//

import SwiftUI


struct RecipeRow: View {
    let recipe: Recipe

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(recipe.equipmentPairName)
            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .accessibilityElement(children: .combine)
    }

    // e.g. "18 g → 36 g · 1:2.0 · 94 °C · 30 s"
    private var subtitle: String {
        let summary = BrewSummary(recipe: recipe)
        let amount = FloatingPointFormatStyle<Double>.number.precision(.fractionLength(0...1))

        var parts = ["\(summary.amountCoffee.formatted(amount))\u{00A0}\(RecipeConstants.Beans.unit) → \(summary.output.formatted(amount))\u{00A0}\(RecipeConstants.Output.unit)"]
        if let ratio = summary.ratio {
            parts.append("1:\(ratio.formatted(.number.precision(.fractionLength(1))))")
        }
        parts.append("\(summary.temperature.formatted(.number))\u{00A0}\(RecipeConstants.Temperature.unit)")
        parts.append("\(summary.extractionTime.formatted(.number))\u{00A0}\(RecipeConstants.ExtractionTime.unit)")

        return parts.joined(separator: " · ")
    }
}


#Preview(traits: .modifier(SampleDataModifier())) {
    List {
        RecipeRow(recipe: .Mock.espressoUsed)
        RecipeRow(recipe: .Mock.espresso)
        RecipeRow(recipe: Recipe(temperature: 94, grindSetting: 10, extractionTime: 33, input: 18.4, output: 37.3))
    }
}
