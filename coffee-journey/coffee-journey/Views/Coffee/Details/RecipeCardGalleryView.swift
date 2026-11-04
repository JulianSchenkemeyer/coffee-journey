//
//  RecipeCardGalleryView.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 07.02.26.
//
import SwiftUI
import SwiftData


struct RecipeCardGalleryView: View {
    let coffee: Coffee
    let recipes: [Recipe]
    var onSelectionChange: (Recipe?) -> Void

    var sortedRecipes: [Recipe] {
        recipes.sorted(using: KeyPathComparator(\.lastUsed, order: .reverse))
    }

    @State private var visibleRecipeID: Recipe.ID?
    @State private var isAddButtonVisible = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recipes")
                .font(.headline)
                .foregroundStyle(.secondary)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(sortedRecipes) { recipe in
                        RecipeCardView(coffee: coffee, recipe: recipe)
                            .frame(width: 300, height: 200)
                    }

                    AddRecipeCardButtonView(coffee: coffee, isInteractive: isAddButtonVisible)
                        .frame(width: 300, height: 200)
                }
                .scrollTargetLayout()
            }
            // onScrollVisibilityChange on the card stops firing after the details screen is re-entered,
            // leaving the button disabled. The add card is always last, so derive its visibility (≥ 90%
            // of its 300pt width) from how close the gallery is scrolled to its end.
            .onScrollGeometryChange(for: Bool.self) { geometry in
                geometry.visibleRect.maxX >= geometry.contentSize.width - 30
            } action: { _, isVisible in
                isAddButtonVisible = isVisible
            }
            .scrollTargetBehavior(.viewAligned)
            .scrollPosition(id: $visibleRecipeID)
            .onChange(of: visibleRecipeID) {
                onSelectionChange(sortedRecipes.first { $0.id == visibleRecipeID })
            }
        }
    }
}

#Preview {
    RecipeCardGalleryView(coffee: .Mock.filter, recipes: Recipe.Mock.all, onSelectionChange: { _ in })
}
