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
    @Environment(\.alertCoordinator) private var alertCoordinator

    var coffee: Coffee
    var recipe: Recipe?

    @State private var selectedBrewer: Equipment?
    @State private var selectedGrinder: Equipment?
    @State private var temperature: Int = RecipeConstants.Temperature.defaultValue
    @State private var grindSetting: Double = RecipeConstants.GrindSetting.defaultValue
    @State private var extractionTime: Int = RecipeConstants.ExtractionTime.defaultValue
    @State private var amountBeans: Double = RecipeConstants.Beans.defaultValue
    @State private var output: Double = RecipeConstants.Output.defaultValue

    
    var body: some View {
        NavigationStack {
            RecipeFormContent(
                selectedBrewer: $selectedBrewer,
                selectedGrinder: $selectedGrinder,
                temperature: $temperature,
                grindSetting: $grindSetting,
                extractionTime: $extractionTime,
                amountBeans: $amountBeans,
                output: $output,
                appliesGrinderStartingPoint: !isEditMode,
                isDuplicate: isDuplicate
            )
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

    private var isDuplicate: Bool {
        coffee.recipes.contains {
            $0.id != recipe?.id && $0.brewer == selectedBrewer && $0.grinder == selectedGrinder
        }
    }

    private var isFormValid: Bool {
        selectedBrewer != nil && selectedGrinder != nil && !isDuplicate
    }

    private func loadRecipeData() {
        guard let recipe = recipe else { return }

        selectedBrewer = recipe.brewer
        selectedGrinder = recipe.grinder
        temperature = recipe.temperature
        grindSetting = recipe.grindSetting
        extractionTime = recipe.extractionTime
        amountBeans = recipe.amountBeans
        output = recipe.output
    }

    private func submit() {
        guard isFormValid else { return }

        do {
            if let recipe = recipe {
                try updateRecipe(recipe)
            } else {
                try createNewRecipe()
            }
            dismiss()
        } catch {
            alertCoordinator.show(error)
        }
    }

    private func updateRecipe(_ recipe: Recipe) throws {
        // Name is no longer editable; keep the stored value until the field is removed from the model.
        let request = UpdateRecipeRequest(
            name: recipe.name,
            brewer: selectedBrewer,
            grinder: selectedGrinder,
            temperature: temperature,
            grindSetting: grindSetting,
            extractionTime: extractionTime,
            amountBeans: amountBeans,
            output: output
        )
        _ = try recipeUseCases.update(recipe, request)
    }

    private func createNewRecipe() throws {
        let request = CreateRecipeRequest(
            grinder: selectedGrinder,
            brewer: selectedBrewer,
            coffee: coffee,
            name: "",
            temperature: temperature,
            grindSetting: grindSetting,
            extractionTime: extractionTime,
            amountBeans: amountBeans,
            output: output
        )

        _ = try recipeUseCases.create(request)
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
