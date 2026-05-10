//
//  ConfirmCalibrationModalView.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 16.02.26.
//
import Foundation
import SwiftUI


struct ConfirmCalibrationModalView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.alertCoordinator) private var alertCoordinator
    @Environment(\.recipeUseCases) private var recipeUseCases
    
    let recipe: Recipe
    let request: CalibrateRecipeRequest
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 14) {
                
                Text(recipe.name)
                    .font(.title2)
                    .foregroundStyle(.secondary)

                Grid(alignment: .leading, horizontalSpacing: 12, verticalSpacing: 8) {
                    GridRow {
                        Text("")
                        Text("Current").bold()
                        Text("")
                        Text("New").bold()
                    }
                    ComparisonRow("Beans:", currentMin: recipe.minAmountBeans, currentMax: recipe.maxAmountBeans, new: request.amountBeans, format: .number.precision(.fractionLength(1)), unit: "g")
                    ComparisonRow("Grind Setting:", currentMin: recipe.minGrindSetting, currentMax: recipe.maxGrindSetting, new: request.grindSetting, format: .number)
                    ComparisonRow("Temperature:", currentMin: recipe.minTemperature, currentMax: recipe.maxTemperature, new: request.temperature, format: .number, unit: "°C")
                    ComparisonRow("Extraction Time:", currentMin: recipe.minExtractionTime, currentMax: recipe.maxExtractionTime, new: request.extractionTime, format: .number, unit: "s")
                    ComparisonRow("Output:", currentMin: recipe.minOutput, currentMax: recipe.maxOutput, new: request.output, format: .number.precision(.fractionLength(1)), unit: "g")
                }
            }
            .navigationTitle("Calibrate Recipe")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(role: .close) {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(role: .confirm) {
                        do {
                            _ = try recipeUseCases.calibrate(request)
                            dismiss()
                        } catch {
                            alertCoordinator.show(error)
                        }
                    }
                }
            }
            
        }
    }
}


private struct ComparisonRow<V: Equatable, F: FormatStyle>: View where F.FormatInput == V, F.FormatOutput == String {
    let label: String
    let currentMin: V
    let currentMax: V
    let new: V
    let format: F
    var unit: String?

    init(_ label: String, currentMin: V, currentMax: V, new: V, format: F, unit: String? = nil) {
        self.label = label
        self.currentMin = currentMin
        self.currentMax = currentMax
        self.new = new
        self.format = format
        self.unit = unit
    }

    var body: some View {
        GridRow {
            Text(label)
            FormattedValueText(min: currentMin, max: currentMax, format: format, unit: unit)
            Image(systemName: "arrow.right")
            FormattedValueText(value: new, format: format, unit: unit)
        }
    }
}

#Preview {
    @Previewable let request = CalibrateRecipeRequest(
        recipe: .Mock.espresso,
        temperature: 96,
        grindSetting: 20.0,
        extractionTime: 300,
        amountBeans: 20.0,
        output: 40.0
    )
    
    Text("test")
        .sheet(isPresented: .constant(true)) {
            ConfirmCalibrationModalView(recipe: .Mock.espresso, request: request)
                .presentationDetents([.fraction(0.45)])
        }
}
