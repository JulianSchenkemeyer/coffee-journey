//
//  SetupRecipeView.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 25.02.26.
//
import Foundation
import SwiftUI
import SwiftData


/// Inline recipe setup form presented after creating a new coffee.
/// Lives within AddCoffeeModalView's NavigationStack, not as a standalone sheet.
struct SetupRecipeView: View {
    @Environment(\.recipeUseCases) private var recipeUseCases
    @Environment(\.sheetCoordinator) private var sheetCoordinator
    @Environment(\.alertCoordinator) private var alertCoordinator

    var coffee: Coffee

    @State private var name: String = ""
    @State private var selectedBrewer: Equipment?
    @State private var selectedGrinder: Equipment?
    @State private var temperature: Int = RecipeConstants.Temperature.defaultValue
    @State private var grindSetting: Double = RecipeConstants.GrindSetting.defaultValue
    @State private var extractionTime: Int = RecipeConstants.ExtractionTime.defaultValue
    @State private var amountBeans: Double = RecipeConstants.Beans.defaultValue
    @State private var output: Double = RecipeConstants.Output.defaultValue


    var body: some View {
        RecipeFormContent(
            name: $name,
            selectedBrewer: $selectedBrewer,
            selectedGrinder: $selectedGrinder,
            temperature: $temperature,
            grindSetting: $grindSetting,
            extractionTime: $extractionTime,
            amountBeans: $amountBeans,
            output: $output,
        )
        .navigationTitle("Set Up Recipe")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Skip") {
                    sheetCoordinator.dismiss()
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button(role: .confirm) { submit() }
                    .disabled(!isFormValid)
            }
        }
    }

    private var isNameValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private var isFormValid: Bool {
        isNameValid
    }

    private func submit() {
        guard isFormValid, let selectedBrewer, let selectedGrinder else { return }

        let request = CreateRecipeRequest(
            grinder: selectedGrinder,
            brewer: selectedBrewer,
            coffee: coffee,
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            temperature: temperature,
            grindSetting: grindSetting,
            extractionTime: extractionTime,
            amountBeans: amountBeans,
            output: output
        )

        do {
            _ = try recipeUseCases.create(request)
            sheetCoordinator.dismiss()
        } catch {
            alertCoordinator.show(error)
        }
    }
}


#Preview(traits: .modifier(SampleDataModifier())) {
    @Previewable @Query var coffees: [Coffee]
    @Previewable @State var isPresented = true
    Color.clear.sheet(isPresented: $isPresented) {
        NavigationStack {
            SetupRecipeView(coffee: coffees.first!)
        }
    }
}
