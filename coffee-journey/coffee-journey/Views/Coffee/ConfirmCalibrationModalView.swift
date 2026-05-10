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

                Grid(alignment: .leading, horizontalSpacing: 16, verticalSpacing: 8) {
                    GridRow {
                        Text("")
                        Text("Recipe").bold()
                        Text("")
                        Text("Brew").bold()

                    }
                    GridRow {
                        Text("Beans:")
                        Text("\(recipe.amountBeans, format: .number.precision(.fractionLength(1))) g")
                        Image(systemName: "arrow.right")
                        Text("\(request.amountBeans, format: .number.precision(.fractionLength(1))) g")
                    }
                    GridRow {
                        Text("Grind Setting:")
                        Text("\(recipe.grindSetting, format: .number)")
                        Image(systemName: "arrow.right")
                        Text("\(request.grindSetting, format: .number)")
                    }
                    GridRow {
                        Text("Temperature:")
                        Text("\(recipe.temperature, format: .number) °C")
                        Image(systemName: "arrow.right")
                        Text("\(request.temperature, format: .number) °C")
                    }
                    GridRow {
                        Text("Extraction Time:")
                        Text("\(recipe.extractionTime, format: .number) s")
                        Image(systemName: "arrow.right")
                        Text("\(request.extractionTime, format: .number) s")
                    }
                    GridRow {
                        Text("Output:")
                        Text("\(recipe.output, format: .number.precision(.fractionLength(1))) g")
                        Image(systemName: "arrow.right")
                        Text("\(request.output, format: .number.precision(.fractionLength(1))) g")
                    }
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
