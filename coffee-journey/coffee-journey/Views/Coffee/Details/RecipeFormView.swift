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
    @State private var temperature: Double = 90.0
    @State private var grindSize: Double = 18.0
    @State private var extractionTime: Int = 25
    @State private var amountBeans: Double = 18.0
    @State private var output: Double = 36.0
    
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
                
                Section("Temperature") {
                    HStack {
                        Text("Temperature")
                        Spacer()
                        Stepper("\(Int(temperature))°C", value: $temperature, in: 70...100)
                            .monospacedDigit()
                    }
                }
                
                Section("Grind Size") {
                    HStack {
                        Text("Grind Size")
                        Spacer()
                        Stepper(String(format: "%.1f", grindSize), value: $grindSize, in: 1...40, step: 0.5)
                            .monospacedDigit()
                    }
                }
                
                Section("Extraction Time") {
                    HStack {
                        Text("Extraction Time")
                        Spacer()
                        Stepper("\(extractionTime)s", value: $extractionTime, in: 10...180)
                            .monospacedDigit()
                    }
                }
                
                Section("Coffee Beans") {
                    HStack {
                        Text("Amount")
                        Spacer()
                        Stepper(String(format: "%.1f g", amountBeans), value: $amountBeans, in: 5...50, step: 0.5)
                            .monospacedDigit()
                    }
                }
                
                Section("Output") {
                    HStack {
                        Text("Output")
                        Spacer()
                        Stepper(String(format: "%.1f ml", output), value: $output, in: 10...500, step: 5)
                            .monospacedDigit()
                    }
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
        grindSize = recipe.grindSize
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
        recipe.minGrindSize = grindSize
        recipe.maxGrindSize = grindSize
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
        guard let selectedBrewer, let selectedGrinder else { return nil }
        
        let request = CreateRecipeRequest(
            grinder: selectedGrinder,
            brewer: selectedBrewer,
            coffee: coffee,
            name: name,
            temperature: temperature,
            grindSize: grindSize,
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

