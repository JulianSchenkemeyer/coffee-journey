//
//  AddRecipeCardButton.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 05.02.26.
//

import SwiftUI


struct AddRecipeCardButtonView: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
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
    }
}


#Preview {
    AddRecipeCardButtonView {
        print("Add recipe tapped")
    }
}
