//
//  BrewDrinkModalView.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 22.11.25.
//

import SwiftUI


struct BrewDrinkModalView: View {
    private enum Stage {
        case parameters
        case rating
        
        var contentTransition: AnyTransition {
            switch self {
            case .parameters:
                .move(edge: .leading)
            case .rating:
                .move(edge: .trailing)
            }
        }
    }

    @Environment(\.sheetCoordinator) private var sheetCoordinator
    @Environment(\.brewUseCases) private var brewUseCases
    @Environment(\.alertCoordinator) private var alertCoordinator

    let coffee: Coffee

    @State private var stage: Stage = .parameters

    @State private var selectedRecipe: Recipe?
    @State private var usedCoffee = RecipeConstants.Beans.defaultValue
    @State private var grindSetting = RecipeConstants.GrindSetting.defaultValue
    @State private var temperature = RecipeConstants.Temperature.defaultValue
    @State private var extractionTime = RecipeConstants.ExtractionTime.defaultValue
    @State private var output = RecipeConstants.Output.defaultValue
    @State private var taste = RecipeConstants.Taste.defaultValue
    @State private var clarity = RecipeConstants.Clarity.defaultValue

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
                switch stage {
                case .parameters:
                    BrewParameterFormView(
                        coffee: coffee,
                        selectedRecipe: $selectedRecipe,
                        usedCoffee: $usedCoffee,
                        grindSetting: $grindSetting,
                        temperature: $temperature,
                        extractionTime: $extractionTime,
                        output: $output
                    )
                    .navigationSubtitle("Fine-tune your brew")
                    .transition(stage.contentTransition)
                    
                case .rating:
                    if let selectedRecipe {
                        BrewRatingFormView(
                            recipe: selectedRecipe,
                            usedCoffee: usedCoffee,
                            grindSetting: grindSetting,
                            temperature: temperature,
                            extractionTime: extractionTime,
                            output: output,
                            taste: $taste,
                            clarity: $clarity,
                            onRate: saveBrew
                        )
                        .navigationSubtitle("How was it?")
                        .transition(stage.contentTransition)
                    }
                }
            }
            .navigationTitle(coffee.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                switch stage {
                case .parameters:
                    ToolbarItem(placement: .cancellationAction) {
                        Button(role: .cancel) {
                            sheetCoordinator.dismiss()
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Next") {
                            withAnimation { stage = .rating }
                        }
                        .disabled(selectedRecipe == nil)
                    }

                case .rating:
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Back") {
                            withAnimation { stage = .parameters }
                        }
                    }
                }
            }
        }
    }

    private func saveBrew(with rating: BrewRating) {
        guard let selectedRecipe else { return }

        let brew = Brew(
            date: .now,
            beanAge: coffee.beanAge,
            amountCoffee: usedCoffee,
            grindSetting: grindSetting,
            temperature: temperature,
            extractionTime: extractionTime,
            taste: Int(taste),
            output: output,
            rating: rating,
            clarity: Int(clarity)
        )

        Task {
            do {
                _ = try await brewUseCases.brew(coffee, brew, selectedRecipe)
                sheetCoordinator.dismiss()
            } catch {
                alertCoordinator.show(error)
            }
        }

    }
}


#Preview {
    BrewDrinkModalView(coffee: Coffee.Mock.espresso)
}
