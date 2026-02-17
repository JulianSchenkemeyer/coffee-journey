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
    @Environment(\.recipeUseCases) private var recipeUseCases
    
    let recipe: Recipe
    let brew: Brew
    
    
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
                        Text("\(brew.amountCoffee, format: .number.precision(.fractionLength(1))) g")
                    }
                    GridRow {
                        Text("Grind Setting:")
                        Text("\(recipe.grindSize, format: .number)")
                        Image(systemName: "arrow.right")
                        Text("\(brew.grindSetting, format: .number)")
                    }
                    GridRow {
                        Text("Temperature:")
                        Text("\(recipe.temperature, format: .number) °C")
                        Image(systemName: "arrow.right")
                        Text("\(brew.waterTemperature, format: .number) °C")
                    }
                    GridRow {
                        Text("Extraction Time:")
                        Text("\(recipe.extractionTime, format: .number) s")
                        Image(systemName: "arrow.right")
                        Text("\(brew.extractionTime, format: .number) s")
                    }
                    GridRow {
                        Text("Output:")
                        Text("\(recipe.output, format: .number.precision(.fractionLength(1))) g")
                        Image(systemName: "arrow.right")
                        Text("\(brew.output, format: .number.precision(.fractionLength(1))) g")
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
                        let request = CalibrateRecipeRequest(
                            recipe: recipe,
                            temperature: brew.waterTemperature,
                            grindSize: brew.grindSetting,
                            extractionTime: brew.extractionTime,
                            amountBeans: brew.amountCoffee,
                            output: brew.output
                        )
                        
                        _ = try! recipeUseCases.calibrate(request)
                        dismiss()
                    }
                }
            }
            
        }
    }
}


#Preview {
    Text("test")
        .sheet(isPresented: .constant(true)) {
            ConfirmCalibrationModalView(recipe: .Mock.espresso, brew: .Mock.brews.first!)
                .presentationDetents([.fraction(0.45)])
        }
}
