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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recipes")
                .font(.headline)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 24)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(recipes) { recipe in
                        RecipeCardView(recipe: recipe)
                            .frame(width: 300)
                    }
                    
                    AddRecipeCardButtonView {
                        print("Add recipe")
                    }
                    .frame(width: 300)
                }
                .scrollTargetLayout()
                .padding(.horizontal, 20)
            }
            .scrollTargetBehavior(.viewAligned)
        }
    }
}

#Preview {
    RecipeCardGalleryView(recipes: Recipe.Mock.all)
        .frame(height: 300)
}
