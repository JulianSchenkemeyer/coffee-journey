//
//  BrewDrinkModalView.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 22.11.25.
//

import SwiftUI


struct BrewDrinkModalView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.coffeeUseCases) private var coffeeUseCases
    
    let coffee: Coffee
    
    @State private var selectedRecipe: Recipe?
    @State private var usedCoffee = 18.0
    @State private var grindSetting = 8.0
    @State private var waterTemperature = 96.0
    @State private var extractionTime = 30
    @State private var output: Double = 36.0
    @State private var taste = 3.0
    
    
    init(coffee: Coffee) {
        self.coffee = coffee
        let last = coffee.lastUsedRecipe
        _selectedRecipe = State(initialValue: last)
        if let last {
            _usedCoffee = State(initialValue: last.amountBeans)
            _grindSetting = State(initialValue: last.grindSize)
            _waterTemperature = State(initialValue: last.temperature)
            _extractionTime = State(initialValue: last.extractionTime)
            _output = State(initialValue: last.output)
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Picker("Recipe", selection: $selectedRecipe) {
                        ForEach(coffee.recipes) { recipe in
                            Text(recipe.name).tag(recipe)
                        }
                    }
                    .onChange(of: selectedRecipe) {
                        guard let selectedRecipe else { return }
                        usedCoffee = selectedRecipe.amountBeans
                        grindSetting = selectedRecipe.grindSize
                        waterTemperature = selectedRecipe.temperature
                        extractionTime = selectedRecipe.extractionTime
                        output = selectedRecipe.output
                    }
                    
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
                        
                        Slider(value: $taste, in: 1...5, step: 1.0) {
                            Text("Taste")
                        } minimumValueLabel: {
                            Text("Sour")
                        } maximumValueLabel: {
                            Text("Bitter")
                        }
                    }
                }
                
                HStack {
                    Button {
                        saveBrew(with: .thumbsDown)
                        dismiss()
                    } label: {
                        Label("Thumbs down", systemImage: "hand.thumbsdown.fill")
                            .labelStyle(.iconOnly)
                            .fontWeight(.semibold)
                            .padding()
                            
                    }
                    .tint(.red)
                    
                    Spacer()
                    
                    Button {
                        saveBrew(with: .thumbsUp)
                        dismiss()
                    } label: {
                        Label("Thumbs Up", systemImage: "hand.thumbsup.fill")
                            .labelStyle(.iconOnly)
                            .fontWeight(.semibold)
                            .padding()
                    }
                }
                .disabled(selectedRecipe == nil)
                .padding(.horizontal, 20)
                .buttonStyle(.glassProminent)
                .frame(maxWidth: .infinity)
            }
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
    
    func saveBrew(with rating: BrewRating) {
        guard let selectedRecipe else { return }
        
        let brew = Brew(
            date: .now,
            amountCoffee: usedCoffee,
            grindSetting: grindSetting,
            waterTemperature: waterTemperature,
            extractionTime: extractionTime,
            taste: Int(taste),
            output: output,
            rating: rating
        )
        _ = try! coffeeUseCases.brew(coffee, brew, selectedRecipe)
    }
}


#Preview {
    BrewDrinkModalView(coffee: Coffee.Mock.espresso)
}

