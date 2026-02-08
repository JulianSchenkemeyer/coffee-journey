//
//  RecipeCardGalleryView.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 07.02.26.
//
import Foundation
import SwiftUI


struct RecipeCardGalleryView: View {
    let recipes: [Recipe]
    
    let onAddRecipe: () -> Void
    let onRecalibrateRecipe: (Recipe) -> Void
    let onEditRecipe: (Recipe) -> Void
    let onDeleteRecipe: (Recipe) -> Void
    
    @State private var isAddButtonInFocus = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recipes")
                .font(.headline)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 24)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(recipes) { recipe in
                        RecipeCardView(
                            recipe: recipe,
                            onRecalibrate: onRecalibrateRecipe,
                            onEdit: onEditRecipe,
                            onDelete: onDeleteRecipe
                        )
                            .frame(width: 300)
                    }
                    
                    AddRecipeCardButtonView(isInteractive: isAddButtonInFocus) {
                        onAddRecipe()
                    }
                    .frame(width: 300)
                    .onScrollVisibilityChange(threshold: 0.9) { isVisible in
                        isAddButtonInFocus = isVisible
                    }
                }
                .scrollTargetLayout()
                .padding(.horizontal, 20)
            }
            .scrollTargetBehavior(.viewAligned)
        }
    }
}

#Preview {
    RecipeCardGalleryView(recipes: Recipe.Mock.all) {
        print("add new recipe")
    } onRecalibrateRecipe: { recipe in
        print("recalibrate \(recipe.name)")
    } onEditRecipe: { recipe in
        print("edit \(recipe.name)")
    } onDeleteRecipe: { recipe in
        print("delete \(recipe.name)")
    }
        .frame(height: 300)
}
