//
//  RecipeCardView.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 02.02.26.
//
import Foundation
import SwiftUI


struct RecipeCardView: View {
    let recipe: Recipe
    
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
    ///   - label: The label text (e.g., "Beans", "Temperature")
    ///   - min: The minimum Double value
    ///   - max: The maximum Double value
    ///   - unit: Optional unit suffix (e.g., "g", "°C", "s")
    /// - Returns: A GridRow view with the label and formatted range
    @ViewBuilder
    private func rangeRow(label: LocalizedStringKey, min: Double, max: Double, unit: String? = nil) -> some View {
        GridRow {
            Text(label)
            Text("\(formatValue(min, unit: unit)) ... \(formatValue(max, unit: unit))")
        }
    }
    
    /// Creates a grid row displaying a label and a min-max range with formatted integer values
    /// - Parameters:
    ///   - label: The label text (e.g., "Extraction")
    ///   - min: The minimum Int value
    ///   - max: The maximum Int value
    ///   - unit: Optional unit suffix (e.g., "s")
    /// - Returns: A GridRow view with the label and formatted range
    @ViewBuilder
    private func rangeRow(label: LocalizedStringKey, min: Int, max: Int, unit: String? = nil) -> some View {
        GridRow {
            Text(label)
            Text("\(formatValue(min, unit: unit)) ... \(formatValue(max, unit: unit))")
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(recipe.name)
                .font(.headline)
            
            Divider()
            
            Grid(alignment: .leading, horizontalSpacing: 48, verticalSpacing: 8) {
                rangeRow(label: "Beans", min: recipe.minAmountBeans, max: recipe.maxAmountBeans, unit: "g")
                rangeRow(label: "Grind Settings", min: recipe.minGrindSize, max: recipe.maxGrindSize)
                rangeRow(label: "Temperature", min: recipe.minTemperature, max: recipe.maxTemperature, unit: "°C")
                rangeRow(label: "Extraction", min: recipe.minExtractionTime, max: recipe.maxExtractionTime, unit: "s")
                rangeRow(label: "Output", min: recipe.minOutput, max: recipe.maxOutput, unit: "g")
            }
        }
        .padding(.vertical)
        .padding(.horizontal, 28)
        .background(.background.secondary, in: RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}


#Preview {
    RecipeCardView(recipe: .Mock.espressoUsed)
}

