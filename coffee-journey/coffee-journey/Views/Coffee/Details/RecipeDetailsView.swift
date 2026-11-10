//
//  RecipeDetailsView.swift
//  coffee-journey
//

import SwiftUI
import SwiftData


struct RecipeDetailsView: View {
    @Environment(\.recipeUseCases) private var recipeUseCases
    @Environment(\.router) private var router
    @Environment(\.sheetCoordinator) private var sheetCoordinator
    @Environment(\.alertCoordinator) private var alertCoordinator

    let coffee: Coffee
    let recipe: Recipe

    @State private var showDeleteConfirmation = false
    @State private var isHeaderScrolledAway = false

    var body: some View {
        // Deleting pops this page; skip rendering the deleted recipe while the pop animates.
        if recipe.isDeleted || recipe.modelContext == nil {
            Color.clear
        } else {
            let oneDecimal = FloatingPointFormatStyle<Double>.number.precision(.fractionLength(1))
            let whole = FloatingPointFormatStyle<Double>.number.precision(.fractionLength(0))
            let recentBrews = recipe.brews.sorted { $0.date > $1.date }.prefix(3)

            List {
                // A wrapping heading instead of a large title, which truncates longer equipment pairs.
                Section {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(recipe.equipmentPairName)
                            .font(.largeTitle.bold())
                        Text(coffee.name)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                    .accessibilityElement(children: .combine)
                    .accessibilityAddTraits(.isHeader)
                }

                Section("Parameters") {
                    Grid(alignment: .leading, horizontalSpacing: 12, verticalSpacing: 10) {
                        RangeBar(label: "Beans", symbol: CJSymbol.BrewParameter.coffee, bounds: RecipeConstants.Beans.range,
                                 min: recipe.minAmountBeans, max: recipe.maxAmountBeans, target: recipe.amountBeans,
                                 format: oneDecimal, unit: RecipeConstants.Beans.unit)
                        RangeBar(label: "Grind", symbol: CJSymbol.BrewParameter.grind, bounds: RecipeConstants.GrindSetting.range,
                                 min: recipe.minGrindSetting, max: recipe.maxGrindSetting, target: recipe.grindSetting,
                                 format: .number.precision(.fractionLength(recipe.grindFractionDigits)))
                        RangeBar(label: "Temp", symbol: CJSymbol.BrewParameter.temperature,
                                 bounds: Double(RecipeConstants.Temperature.range.lowerBound)...Double(RecipeConstants.Temperature.range.upperBound),
                                 min: Double(recipe.minTemperature), max: Double(recipe.maxTemperature), target: Double(recipe.temperature),
                                 format: whole, unit: RecipeConstants.Temperature.unit)
                        RangeBar(label: "Time", symbol: CJSymbol.BrewParameter.time,
                                 bounds: Double(RecipeConstants.ExtractionTime.range.lowerBound)...Double(RecipeConstants.ExtractionTime.range.upperBound),
                                 min: Double(recipe.minExtractionTime), max: Double(recipe.maxExtractionTime), target: Double(recipe.extractionTime),
                                 format: whole, unit: RecipeConstants.ExtractionTime.unit)
                        RangeBar(label: "Output", symbol: CJSymbol.BrewParameter.output, bounds: RecipeConstants.Output.range,
                                 min: recipe.minOutput, max: recipe.maxOutput, target: recipe.output,
                                 format: oneDecimal, unit: RecipeConstants.Output.unit)
                    }
                }

                Section("Brews") {
                    if recipe.brews.isEmpty {
                        Text("No brews with this recipe yet.")
                            .foregroundStyle(.secondary)
                    } else {
                        BrewTasteDistributionChartView(brews: recipe.brews, recipe: recipe)

                        ForEach(recentBrews) { brew in
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(brew.date, format: .dateTime.day().month().hour().minute())
                                    Text(brew.tasteDescription.description)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                Text(brew.rating == .thumbsUp ? "👍" : "👎")
                            }
                            .accessibilityElement(children: .combine)
                        }

                        RouteLink(.brewHistory(coffee, recipe)) {
                            Text("Show All Brews")
                        }
                    }
                }
            }
            // The bar shows the pair only once the heading has scrolled out of view.
            .navigationTitle(isHeaderScrolledAway ? recipe.equipmentPairName : "")
            .navigationBarTitleDisplayMode(.inline)
            .onScrollGeometryChange(for: Bool.self) { geometry in
                geometry.contentOffset.y + geometry.contentInsets.top > 60
            } action: { _, isScrolledAway in
                isHeaderScrolledAway = isScrolledAway
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Brew", systemImage: CJSymbol.Action.brew) {
                        sheetCoordinator.present(.brew(coffee, recipe))
                    }
                    .buttonStyle(.glassProminent)
                }

                ToolbarSpacer(.fixed, placement: .topBarTrailing)

                ToolbarItem(placement: .topBarTrailing) {
                    Menu("Actions", systemImage: "ellipsis") {
                        Button("Calibrate", systemImage: CJSymbol.Action.calibrate) {
                            let calibrationRequest = CalibrateRecipeRequest(
                                recipe: recipe,
                                temperature: recipe.temperature,
                                grindSetting: recipe.grindSetting,
                                extractionTime: recipe.extractionTime,
                                amountBeans: recipe.amountBeans,
                                output: recipe.output
                            )
                            sheetCoordinator.present(.confirmRecipeCalibration(recipe, calibrationRequest))
                        }

                        Button("Edit Recipe", systemImage: CJSymbol.Action.edit) {
                            sheetCoordinator.present(.editRecipe(coffee, recipe))
                        }

                        Divider()

                        Button("Delete", systemImage: CJSymbol.Action.delete, role: .destructive) {
                            showDeleteConfirmation = true
                        }
                    }
                }
            }
            .alert("Delete this recipe?", isPresented: $showDeleteConfirmation) {
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
                Text("\(recipe.equipmentPairName) will be permanently deleted.")
            }
        }
    }
}


#Preview(traits: .modifier(SampleDataModifier())) {
    // A stored recipe: the view hides recipes that have no model context, as after a delete.
    @Previewable @Query(filter: #Predicate<Recipe> { !$0.brews.isEmpty }) var recipes: [Recipe]

    NavigationStack {
        // The longest name, to show the heading wrapping.
        if let recipe = recipes.max(by: { $0.equipmentPairName.count < $1.equipmentPairName.count }), let coffee = recipe.coffee {
            RecipeDetailsView(coffee: coffee, recipe: recipe)
        }
    }
}
