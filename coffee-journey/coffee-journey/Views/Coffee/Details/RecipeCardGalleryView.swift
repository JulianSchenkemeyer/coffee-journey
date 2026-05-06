//
//  RecipeCardGalleryView.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 07.02.26.
//
import Foundation
import SwiftUI


struct RecipeCardGalleryView: View {
    let coffee: Coffee
    let recipes: [Recipe]
    
    var sortedRecipes: [Recipe] {
        recipes.sorted(using: KeyPathComparator(\.lastUsed, order: .reverse))
    }
    
    @State private var isAddButtonInFocus = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recipes")
                .font(.headline)
                .foregroundStyle(.secondary)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(sortedRecipes) { recipe in
                        RecipeCardView(coffee: coffee, recipe: recipe)
                            .frame(width: 300, height: 240)
                    }
                    
                    AddRecipeCardButtonView(coffee: coffee, isInteractive: isAddButtonInFocus)
                        .frame(width: 300, height: 240)
                        .onScrollVisibilityChange(threshold: 0.9) { isVisible in
                            isAddButtonInFocus = isVisible
                        }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
        }
    }
}

#Preview {
    RecipeCardGalleryView(coffee: .Mock.filter, recipes: Recipe.Mock.all)
}
