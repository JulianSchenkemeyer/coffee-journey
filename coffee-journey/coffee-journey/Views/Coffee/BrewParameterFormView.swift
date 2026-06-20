//
//  BrewParameterFormView.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 20.06.26.
//

import SwiftUI


struct BrewParameterFormView: View {
    let coffee: Coffee

    @Binding var selectedRecipe: Recipe?
    @Binding var usedCoffee: Double
    @Binding var grindSetting: Double
    @Binding var temperature: Int
    @Binding var extractionTime: Int
    @Binding var output: Double

    var body: some View {
        Form {
            Picker("Recipe", selection: $selectedRecipe) {
                ForEach(coffee.recipes) { recipe in
                    Text(recipe.name).tag(recipe)
                }
            }
            .onChange(of: selectedRecipe) {
                guard let selectedRecipe else { return }
                usedCoffee = selectedRecipe.amountBeans
                grindSetting = selectedRecipe.grindSetting
                temperature = selectedRecipe.temperature
                extractionTime = selectedRecipe.extractionTime
                output = selectedRecipe.output
            }

            Section("Preperation") {
                Stepper("Beans: \(usedCoffee, format: .number.precision(.fractionLength(1))) \(RecipeConstants.Beans.unit)",
                        value: $usedCoffee,
                        in: RecipeConstants.Beans.range,
                        step: RecipeConstants.Beans.step)

                Stepper("Grind Setting: \(grindSetting, format: .number)",
                        value: $grindSetting,
                        in: RecipeConstants.GrindSetting.range,
                        step: RecipeConstants.GrindSetting.step)
            }

            Section("Process") {
                Stepper("Temperature: \(temperature, format: .number) \(RecipeConstants.Temperature.unit)",
                        value: $temperature,
                        in: RecipeConstants.Temperature.range,
                        step: RecipeConstants.Temperature.step)

                Stepper("Extraction Time: \(extractionTime, format: .number) \(RecipeConstants.ExtractionTime.unit)",
                        value: $extractionTime,
                        in: RecipeConstants.ExtractionTime.range,
                        step: RecipeConstants.ExtractionTime.step)

                Stepper("Output: \(output, format: .number.precision(.fractionLength(1))) \(RecipeConstants.Output.unit)",
                        value: $output,
                        in: RecipeConstants.Output.range,
                        step: RecipeConstants.Output.step)
            }
        }
    }
}
