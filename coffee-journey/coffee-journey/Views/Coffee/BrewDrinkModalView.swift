//
//  BrewDrinkModalView.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 22.11.25.
//

import SwiftUI


struct BrewDrinkModalView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.brewUseCases) private var brewUseCases
    
    let coffee: Coffee
    
    @State private var selectedRecipe: Recipe?
    @State private var usedCoffee = RecipeConstants.Beans.defaultValue
    @State private var grindSetting = RecipeConstants.GrindSetting.defaultValue
    @State private var temperature = RecipeConstants.Temperature.defaultValue
    @State private var extractionTime = RecipeConstants.ExtractionTime.defaultValue
    @State private var output = RecipeConstants.Output.defaultValue
    @State private var taste = RecipeConstants.Taste.defaultValue
    
    
    init(coffee: Coffee) {
        self.coffee = coffee
        let last = coffee.lastUsedRecipe
        _selectedRecipe = State(initialValue: last)
        if let last {
            _usedCoffee = State(initialValue: last.amountBeans)
            _grindSetting = State(initialValue: last.grindSetting)
            _temperature = State(initialValue: last.temperature)
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
                        grindSetting = selectedRecipe.grindSetting
                        temperature = selectedRecipe.temperature
                        extractionTime = selectedRecipe.extractionTime
                        output = selectedRecipe.output
                    }
                    
                    Section("Preperation") {
                        Stepper("Beans: \(usedCoffee, format: .number.precision(.fractionLength(1))) \(RecipeConstants.Beans.unit)",
                                value: $usedCoffee,
                                in: RecipeConstants.Beans.range,
                                step: RecipeConstants.Beans.step)
                        
                        Stepper("Grind Setting: \(grindSetting, format: .number)",
                                value: $grindSetting,
                                in: RecipeConstants.GrindSetting.range,
                                step: RecipeConstants.GrindSetting.step)
                    }
                    
                    Section("Process") {
                        Stepper("Temperature: \(temperature, format: .number) \(RecipeConstants.Temperature.unit)",
                                value: $temperature,
                                in: RecipeConstants.Temperature.range,
                                step: RecipeConstants.Temperature.step)
                        
                        Stepper("Extraction Time: \(extractionTime, format: .number) \(RecipeConstants.ExtractionTime.unit)",
                                value: $extractionTime,
                                in: RecipeConstants.ExtractionTime.range,
                                step: RecipeConstants.ExtractionTime.step)
                    }
                    
                    Section() {
                        Stepper("Output: \(output, format: .number.precision(.fractionLength(1))) \(RecipeConstants.Output.unit)",
                                value: $output,
                                in: RecipeConstants.Output.range,
                                step: RecipeConstants.Output.step)
                        
                        Slider(value: $taste, in: RecipeConstants.Taste.range, step: RecipeConstants.Taste.step) {
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
            temperature: temperature,
            extractionTime: extractionTime,
            taste: Int(taste),
            output: output,
            rating: rating
        )
        _ = try! brewUseCases.brew(coffee, brew, selectedRecipe)
    }
}


#Preview {
    BrewDrinkModalView(coffee: Coffee.Mock.espresso)
}

