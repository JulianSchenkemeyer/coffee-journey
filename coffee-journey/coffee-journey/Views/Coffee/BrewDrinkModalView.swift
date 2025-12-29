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
    @State private var grindSetting = 8.0
    @State private var waterTemperature = 96.0
    @State private var extractionTime = 30
    @State private var output: Double = 36.0
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section("Preperation") {
                        Stepper("Beans: \(usedCoffee, format: .number.precision(.fractionLength(1))) g",
                                value: $usedCoffee,
                                in: 0...50,
                                step: 0.1)
                        
                        Stepper("Grind Setting: \(grindSetting, format: .number)",
                                value: $grindSetting,
                                in: 0...50,
                                step: 1.0)
                    }
                    
                    Section("Process") {
                        
                        Stepper("Temperature: \(waterTemperature, format: .number) °C",
                                value: $waterTemperature,
                                in: 80...100,
                                step: 1.0)
                        
                        Stepper("Extraction Time: \(extractionTime, format: .number) s",
                                value: $extractionTime,
                                in: 0...180,
                                step: 1)
                    }
                    
                    Section() {
                        Stepper("Output: \(output, format: .number.precision(.fractionLength(1))) g",
                                value: $output,
                                in: 0...100,
                                step: 0.1)
                    }
                }
                
                Button {
                    let recipe = Recipe(
//                        grinder: ,
//                        brewer: <#T##Equipment#>,
                        amountCoffee: usedCoffee,
                        grindSetting: grindSetting,
                        waterTemperature: waterTemperature,
                        extractionTime: extractionTime,
                        output: output
                    )
                    _ = try! useCases.brewDrink(coffee, recipe)
                    dismiss()
                } label: {
                    Label("Brew Cup", systemImage: "cup.and.heat.waves.fill")
                        .fontWeight(.semibold)
                        .padding()
                }
            }
            .buttonStyle(.glassProminent)
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
