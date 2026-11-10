//
//  RecipeListView.swift
//  coffee-journey
//

import SwiftUI


struct RecipeListView: View {
    @Environment(\.sheetCoordinator) private var sheetCoordinator

    let coffee: Coffee

    var body: some View {
        List {
            ForEach(coffee.recentRecipes) { recipe in
                RouteLink(.recipeDetails(coffee, recipe)) {
                    RecipeRow(recipe: recipe)
                }
                .recipeActions(coffee: coffee, recipe: recipe)
            }
        }
        .overlay {
            if coffee.recipes.isEmpty {
                ContentUnavailableView(
                    "No Recipes",
                    systemImage: CJSymbol.Coffee.brew,
                    description: Text("Add a recipe for one of your brewer and grinder pairs.")
                )
            }
        }
        .navigationTitle("Recipes")
        .navigationSubtitle(coffee.name)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Add Recipe", systemImage: CJSymbol.Action.add) {
                    sheetCoordinator.present(.editRecipe(coffee, nil))
                }
            }
        }
    }
}


#Preview(traits: .modifier(SampleDataModifier())) {
    NavigationStack {
        RecipeListView(coffee: .Mock.espresso)
    }
}
