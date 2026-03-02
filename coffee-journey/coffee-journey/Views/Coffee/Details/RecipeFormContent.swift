//
//  RecipeFormContent.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 25.02.26.
//
import SwiftUI
import SwiftData


/// Shared form body used by both RecipeFormView and SetupRecipeView.
/// Owns all form field state and exposes it via bindings.
struct RecipeFormContent: View {
    @Query(filter: Equipment.isBrewer) private var brewers: [Equipment]
    @Query(filter: Equipment.isGrinder) private var grinders: [Equipment]

    @Binding var name: String
    @Binding var selectedBrewer: Equipment?
    @Binding var selectedGrinder: Equipment?
    @Binding var temperature: Int
    @Binding var grindSetting: Double
    @Binding var extractionTime: Int
    @Binding var amountBeans: Double
    @Binding var output: Double
    @Binding var submitErrorMessage: String?

    var body: some View {
        Form {
            Section {
                TextField("Recipe Name", text: $name)
                    .textInputAutocapitalization(.words)

                Picker("Brewer", selection: $selectedBrewer) {
                    ForEach(brewers) { brewer in
                        Text(brewer.name)
                            .tag(brewer)
                    }
                }

                Picker("Grinder", selection: $selectedGrinder) {
                    ForEach(grinders) { grinder in
                        Text(grinder.name)
                            .tag(grinder)
                    }
                }
            }

            Section("Preperation") {
                Stepper("Beans: \(amountBeans, format: .number.precision(.fractionLength(1))) \(RecipeConstants.Beans.unit)",
                        value: $amountBeans,
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
            }

            Section("Output") {
                Stepper("Output: \(output, format: .number.precision(.fractionLength(1))) \(RecipeConstants.Output.unit)",
                        value: $output,
                        in: RecipeConstants.Output.range,
                        step: RecipeConstants.Output.step)
            }

            if let submitErrorMessage {
                Section {
                    Text(submitErrorMessage)
                        .foregroundStyle(.red)
                }
            }
        }
    }
}
