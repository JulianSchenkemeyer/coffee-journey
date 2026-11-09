//
//  RecipeActions.swift
//  coffee-journey
//

import SwiftUI


// Calibrate, edit, show brews and delete for a recipe row, via context menu and swipe actions.
private struct RecipeActionsModifier: ViewModifier {
    @Environment(\.recipeUseCases) private var recipeUseCases
    @Environment(\.router) private var router
    @Environment(\.sheetCoordinator) private var sheetCoordinator
    @Environment(\.alertCoordinator) private var alertCoordinator

    let coffee: Coffee
    let recipe: Recipe

    @State private var showDeleteConfirmation = false

    func body(content: Content) -> some View {
        content
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
                    sheetCoordinator.present(.confirmRecipeCalibration(recipe, calibrationRequest))
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
            } preview: {
                // The default preview drops the subtitle and padding of rows outside a List.
                RecipeRow(recipe: recipe)
                    .padding(16)
            }
            .swipeActions {
                // Not `role: .destructive`, which would remove the row before the confirmation is answered.
                Button("Delete", systemImage: CJSymbol.Action.delete) {
                    showDeleteConfirmation = true
                }
                .tint(.red)

                Button("Edit", systemImage: CJSymbol.Action.edit) {
                    sheetCoordinator.present(.editRecipe(coffee, recipe))
                }
                .tint(.accentColor)
            }
            .alert("Delete this recipe?", isPresented: $showDeleteConfirmation) {
                Button("Delete", role: .destructive) {
                    do {
                        try recipeUseCases.delete(recipe)
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


extension View {
    func recipeActions(coffee: Coffee, recipe: Recipe) -> some View {
        modifier(RecipeActionsModifier(coffee: coffee, recipe: recipe))
    }
}
