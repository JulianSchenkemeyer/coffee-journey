//
//  AddRecipeCardButton.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 05.02.26.
//

import SwiftUI


struct AddRecipeCardButtonView: View {
    @Environment(\.sheetCoordinator) private var sheetCoordinator

    let coffee: Coffee
    let isInteractive: Bool
    
    var body: some View {
        Button {
            sheetCoordinator.present(.editRecipe(coffee, nil))
        } label: {
            VStack(spacing: 12) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(.secondary)
                
                Text("Add Recipe")
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain)
        .allowsHitTesting(isInteractive)
    }
}


#Preview {
    AddRecipeCardButtonView(coffee: .Mock.darkRoast, isInteractive: true)
}
