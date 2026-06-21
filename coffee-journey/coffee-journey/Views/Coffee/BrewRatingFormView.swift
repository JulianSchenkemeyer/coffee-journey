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

    var body: some View {
        Form {
            Section("Summary") {
                LabeledContent("Recipe", value: recipe.name)
                LabeledContent("Beans", value: "\(usedCoffee.formatted(.number.precision(.fractionLength(1)))) \(RecipeConstants.Beans.unit)")
                LabeledContent("Grind Setting", value: grindSetting.formatted(.number.precision(.fractionLength(0))))
                LabeledContent("Temperature", value: "\(temperature) \(RecipeConstants.Temperature.unit)")
                LabeledContent("Extraction Time", value: "\(extractionTime) \(RecipeConstants.ExtractionTime.unit)")
                LabeledContent("Output", value: "\(output.formatted(.number.precision(.fractionLength(1)))) \(RecipeConstants.Output.unit)")
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
