//
//  BrewDrinkModalView.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 22.11.25.
//

import SwiftUI


struct BrewDrinkModalView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.useCases) private var useCases: UseCases
    
    let coffee: Coffee
    
    @State private var usedCoffee = 18.0
    @State private var usedWater = 58.0
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                VStack {
                    Stepper("Coffee: \(usedCoffee, format: .number.precision(.fractionLength(1))) g",
                            value: $usedCoffee,
                            in: 0...50,
                            step: 0.1)
                    
                    Stepper("Water: \(usedWater, format: .number.precision(.fractionLength(1))) g",
                            value: $usedWater,
                            in: 0...100,
                            step: 0.1)
                }
                .padding(.vertical, 8)
                
                Button {
                    _ = try! useCases.brewDrink(coffee)
                    dismiss()
                } label: {
                    Label("Brew Cup", systemImage: "cup.and.heat.waves.fill")
                        .fontWeight(.semibold)
                        .padding()
                }
                .buttonStyle(.glassProminent)
                .frame(maxWidth: .infinity)
            }
            .padding(24)
            .frame(maxHeight: .infinity, alignment: .top)
            .navigationTitle(coffee.name)
            .navigationSubtitle("Fine-tune your brew")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(role: .cancel) {
                        dismiss()
                    }
                }
            }
        }
    }
}


#Preview {
    BrewDrinkModalView(coffee: Coffee.Mock.espresso)
}
