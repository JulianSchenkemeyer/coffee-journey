//
//  RecipeCardView.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 02.02.26.
//
import Foundation
import SwiftUI
import SwiftData


struct RecipeCardView: View {
    @Environment(\.recipeUseCases) private var recipeUseCases
    @Environment(\.router) private var router
    @Environment(\.sheetCoordinator) private var sheetCoordinator
    @Environment(\.alertCoordinator) private var alertCoordinator
    
    let coffee: Coffee
    let recipe: Recipe
    
    @State private var showDeleteConfirmation = false
    
    
    private func rangeRow<V: Equatable, F: FormatStyle>(icon: String, label: LocalizedStringKey, min: V, max: V, format: F, unit: String? = nil) -> some View where F.FormatInput == V, F.FormatOutput == String {
        GridRow {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .foregroundStyle(.secondary)
                    .frame(width: 20)
                Text(label)
                    .foregroundStyle(.secondary)
            }
            FormattedValueText(min: min, max: max, format: format, unit: unit)
                .monospaced()
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(recipe.name)
                    .font(.title3)
                    .fontWeight(.semibold)
             
                Spacer()
                
                Label("Recipe Actions", systemImage: "ellipsis")
                    .labelStyle(.iconOnly)
            }
            
            HStack {
                if let grinder = recipe.grinder {
                    Text(grinder.name)
                        .font(.caption2.bold())
                        .padding(4)
                        .padding(.horizontal, 6)
                        .background(Capsule().opacity(0.3))
                }
                
                if let brewer = recipe.brewer {
                    Text(brewer.name)
                        .font(.caption2.bold())
                        .padding(4)
                        .padding(.horizontal, 6)
                        .background(Capsule().opacity(0.3))
                }
            }
            
            Divider()
            
            Grid(alignment: .leading, horizontalSpacing: 16, verticalSpacing: 8) {
                rangeRow(icon: "scalemass.fill", label: "Beans", min: recipe.minAmountBeans, max: recipe.maxAmountBeans, format: .number.precision(.fractionLength(1)), unit: "g")
                rangeRow(icon: "dial.high.fill", label: "Grind", min: recipe.minGrindSetting, max: recipe.maxGrindSetting, format: .number)
                rangeRow(icon: "thermometer.medium", label: "Temp", min: recipe.minTemperature, max: recipe.maxTemperature, format: .number, unit: "°C")
                rangeRow(icon: "timer", label: "Time", min: recipe.minExtractionTime, max: recipe.maxExtractionTime, format: .number, unit: "s")
                rangeRow(icon: "drop.fill", label: "Output", min: recipe.minOutput, max: recipe.maxOutput, format: .number.precision(.fractionLength(1)), unit: "g")
            }
            .font(.subheadline)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .padding(16)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
        .contextMenu {
            Button("Recalibrate", systemImage: CJSymbol.Action.recalibrate) {
                
                let calibrationRequest = CalibrateRecipeRequest(
                    recipe: recipe,
                    temperature: recipe.temperature,
                    grindSetting: recipe.grindSetting,
                    extractionTime: recipe.extractionTime,
                    amountBeans: recipe.amountBeans,
                    output: recipe.output
                )
                
                do {
                    sheetCoordinator.present(.confirmRecipeCalibration(recipe, calibrationRequest))
                } catch {
                    alertCoordinator.show(error)
                }
            }
            
            Button("Edit Recipe", systemImage: CJSymbol.Action.edit) {
                sheetCoordinator.present(.editRecipe(coffee, recipe))
            }
            
            Button("Show Brews", systemImage: CJSymbol.Navigation.brewHistory) {
                router.navigate(to: .brewHistory(coffee, recipe))
            }
            
            Divider()
            
            Button("Delete", systemImage: CJSymbol.Action.delete, role: .destructive) {
                showDeleteConfirmation = true
            }
        }
        .alert("Delete \(recipe.name)?", isPresented: $showDeleteConfirmation) {
            Button("Delete", role: .destructive) {
                do {
                    try recipeUseCases.delete(recipe)
                    router.navigateBack()
                } catch {
                    alertCoordinator.show(error)
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will permanently delete this recipe.")
        }
    }
}


#Preview(traits: .modifier(SampleDataModifier())) {
    RecipeCardView(coffee: .Mock.darkRoast, recipe: .Mock.turboUsed)
}

