//
//  RecipeFormView.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 15.02.26.
//
import Foundation
import SwiftUI
import SwiftData


struct RecipeFormView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.recipeUseCases) private var recipeUseCases
    
    @Query(filter: Equipment.isBrewer) private var brewers: [Equipment]
    @Query(filter: Equipment.isGrinder) private var grinders: [Equipment]
    
    var coffee: Coffee
    var recipe: Recipe?
    
    @State private var name: String = ""
    @State private var selectedBrewer: Equipment?
    @State private var selectedGrinder: Equipment?
    @State private var temperature: Int = RecipeConstants.Temperature.defaultValue
    @State private var grindSetting: Double = RecipeConstants.GrindSetting.defaultValue
    @State private var extractionTime: Int = RecipeConstants.ExtractionTime.defaultValue
    @State private var amountBeans: Double = RecipeConstants.Beans.defaultValue
    @State private var output: Double = RecipeConstants.Output.defaultValue
    
    @State private var submitErrorMessage: String? = nil
        

    
    var body: some View {
        NavigationStack {
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
            .navigationTitle(isEditMode ? "Edit Recipe" : "New Recipe")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(role: .close) {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(role: .confirm) { submit() }
                        .disabled(!isFormValid)
                }
            }
            .onAppear {
                loadRecipeData()
            }
        }
    }
    
    private var isEditMode: Bool { recipe != nil }
    
    private var isNameValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private var isFormValid: Bool {
        isNameValid
    }
    
    private func loadRecipeData() {
        guard let recipe = recipe else { return }
        
        name = recipe.name
        selectedBrewer = recipe.brewer
        selectedGrinder = recipe.grinder
        temperature = recipe.temperature
        grindSetting = recipe.grindSetting
        extractionTime = recipe.extractionTime
        amountBeans = recipe.amountBeans
        output = recipe.output
    }
    
    private func submit() {
        submitErrorMessage = nil
        guard isFormValid else { return }
        
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        do {
            if let recipe = recipe {
                // Edit mode - update existing recipe
                try updateRecipe(recipe, name: trimmedName)
            } else {
                // Create mode - create new recipe
                try createNewRecipe(name: trimmedName)
            }
            dismiss()
        } catch {
            submitErrorMessage = error.localizedDescription
        }
    }
    
    private func updateRecipe(_ recipe: Recipe, name: String) throws {
        recipe.name = name
        recipe.brewer = selectedBrewer
        recipe.grinder = selectedGrinder
        recipe.minTemperature = temperature
        recipe.maxTemperature = temperature
        recipe.minGrindSetting = grindSetting
        recipe.maxGrindSetting = grindSetting
        recipe.minExtractionTime = extractionTime
        recipe.maxExtractionTime = extractionTime
        recipe.minAmountBeans = amountBeans
        recipe.maxAmountBeans = amountBeans
        recipe.minOutput = output
        recipe.maxOutput = output
        
        _ = try recipeUseCases.update(recipe)
    }
    
    @discardableResult
    private func createNewRecipe(name: String) throws -> Recipe? {
        //TODO: Error Handling
        guard let selectedBrewer, let selectedGrinder else { return nil }
        
        let request = CreateRecipeRequest(
            grinder: selectedGrinder,
            brewer: selectedBrewer,
            coffee: coffee,
            name: name,
            temperature: temperature,
            grindSetting: grindSetting,
            extractionTime: extractionTime,
            amountBeans: amountBeans,
            output: output
        )
        
        return try recipeUseCases.create(request)
    }
}


#Preview("Create New Recipe", traits: .modifier(SampleDataModifier())) {
    @Previewable @Query var coffees: [Coffee]
    return RecipeFormView(coffee: coffees.first!)
}

#Preview("Edit Existing Recipe", traits: .modifier(SampleDataModifier())) {
    @Previewable @Query var coffees: [Coffee]
    let coffee = coffees.first!
    return RecipeFormView(coffee: coffee, recipe: coffee.recipes.first!)
}

