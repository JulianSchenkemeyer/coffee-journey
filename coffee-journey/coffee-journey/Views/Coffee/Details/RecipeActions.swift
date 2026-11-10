//
//  RecipeActions.swift
//  coffee-journey
//

import SwiftUI


// Edit and delete swipe actions for a recipe row; the remaining actions live on the recipe's detail page.
private struct RecipeActionsModifier: ViewModifier {
    @Environment(\.recipeUseCases) private var recipeUseCases
    @Environment(\.sheetCoordinator) private var sheetCoordinator
    @Environment(\.alertCoordinator) private var alertCoordinator

    let coffee: Coffee
    let recipe: Recipe

    @State private var showDeleteConfirmation = false

    func body(content: Content) -> some View {
        content
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
