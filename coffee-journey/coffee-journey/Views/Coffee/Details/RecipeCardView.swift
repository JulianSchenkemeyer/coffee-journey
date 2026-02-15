//
//  RecipeCardView.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 02.02.26.
//
import Foundation
import SwiftUI


struct RecipeCardView: View {
    @Environment(\.useCases) private var useCases
    @Environment(\.router) private var router
    
    let recipe: Recipe
    
    @State private var isEditing: Bool = false

    
    // MARK: - Helper Methods
    
    /// Formats a Double value with one decimal place precision and an optional unit suffix
    /// - Parameters:
    ///   - value: The Double value to format
    ///   - unit: Optional unit suffix (e.g., "g", "°C", "s")
    /// - Returns: Formatted string with the value and optional unit
    private func formatValue(_ value: Double, unit: String? = nil) -> String {
        let formattedNumber = value.formatted(.number.precision(.fractionLength(1)))
        return formattedNumber + (unit ?? "")
    }
    
    /// Formats an Int value with an optional unit suffix
    /// - Parameters:
    ///   - value: The Int value to format
    ///   - unit: Optional unit suffix (e.g., "g", "°C", "s")
    /// - Returns: Formatted string with the value and optional unit
    private func formatValue(_ value: Int, unit: String? = nil) -> String {
        let formattedNumber = "\(value)"
        return formattedNumber + (unit ?? "")
    }
    
    // MARK: - View Helpers
    
    /// Creates a grid row displaying a label and a min-max range with formatted values
    /// - Parameters:
    ///   - icon: Optional SF Symbol icon name
    ///   - label: The label text (e.g., "Beans", "Temperature")
    ///   - min: The minimum Double value
    ///   - max: The maximum Double value
    ///   - unit: Optional unit suffix (e.g., "g", "°C", "s")
    /// - Returns: A GridRow view with the label and formatted range
    @ViewBuilder
    private func rangeRow(icon: String? = nil, label: LocalizedStringKey, min: Double, max: Double, unit: String? = nil) -> some View {
        GridRow {
            HStack(spacing: 6) {
                if let icon {
                    Image(systemName: icon)
                        .foregroundStyle(.secondary)
                        .frame(width: 20)
                }
                Text(label)
                    .foregroundStyle(.secondary)
            }
            if min == max {
                Text(formatValue(min, unit: unit))
                    .monospaced()
            } else {
                Text("\(formatValue(min, unit: unit)) ... \(formatValue(max, unit: unit))")
                    .monospaced()
            }
        }
    }
    
    /// Creates a grid row displaying a label and a min-max range with formatted integer values
    /// - Parameters:
    ///   - icon: Optional SF Symbol icon name
    ///   - label: The label text (e.g., "Extraction")
    ///   - min: The minimum Int value
    ///   - max: The maximum Int value
    ///   - unit: Optional unit suffix (e.g., "s")
    /// - Returns: A GridRow view with the label and formatted range
    @ViewBuilder
    private func rangeRow(icon: String? = nil, label: LocalizedStringKey, min: Int, max: Int, unit: String? = nil) -> some View {
        GridRow {
            HStack(spacing: 6) {
                if let icon {
                    Image(systemName: icon)
                        .foregroundStyle(.primary)
                        .frame(width: 20)
                }
                Text(label)
                    .foregroundStyle(.secondary)
            }
            if min == max {
                Text(formatValue(min, unit: unit))
                    .monospaced()
            } else {
                Text("\(formatValue(min, unit: unit)) ... \(formatValue(max, unit: unit))")
                    .monospaced()
            }
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
            
            Divider()
            
            Grid(alignment: .leading, horizontalSpacing: 16, verticalSpacing: 8) {
                rangeRow(icon: "scalemass.fill", label: "Beans", min: recipe.minAmountBeans, max: recipe.maxAmountBeans, unit: "g")
                rangeRow(icon: "dial.high.fill", label: "Grind", min: recipe.minGrindSize, max: recipe.maxGrindSize)
                rangeRow(icon: "thermometer.medium", label: "Temp", min: recipe.minTemperature, max: recipe.maxTemperature, unit: "°C")
                rangeRow(icon: "timer", label: "Time", min: recipe.minExtractionTime, max: recipe.maxExtractionTime, unit: "s")
                rangeRow(icon: "drop.fill", label: "Output", min: recipe.minOutput, max: recipe.maxOutput, unit: "g")
            }
            .font(.subheadline)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
        .sheet(isPresented: $isEditing, content: {
            Text("Test")
        })
        .contextMenu {
            Button("Recalibrate", systemImage: "gearshape.arrow.trianglehead.2.clockwise.rotate.90") {
                _ = try! useCases.recalibrateRecipe(recipe)
            }
            
            Button("Edit", systemImage: "pencil") {
                isEditing = true
            }
            
            Button("Show Brews", systemImage: "square.stack.fill") {
                print(recipe.coffee ?? "no coffee")
        
                if let coffee = recipe.coffee {
                    router.navigate(to: .brewHistory(coffee, recipe))
                }
                
                //TODO: error handling
            }
            
            Divider()
            
            Button("Delete", systemImage: "trash", role: .destructive) {
                print("delete")
            }
        }
    }
}


#Preview {
    PreviewUseCaseEnvironment {
        RecipeCardView(recipe: .Mock.espressoUsed)
    }
}

