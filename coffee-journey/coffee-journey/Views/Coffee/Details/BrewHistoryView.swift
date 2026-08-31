//
//  BrewsOverviewView.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 10.02.26.
//
import Foundation
import SwiftUI
import SwiftData


struct BrewHistoryView: View {
    let coffee: Coffee
    
    @State private var selectedRecipe: Recipe?
    
    init(coffee: Coffee, recipe: Recipe? = nil) {
        self.coffee = coffee
        _selectedRecipe = State(initialValue: recipe)
    }
    
    var body: some View {
        BrewHistoryList(
            coffee: coffee,
            selectedRecipe: selectedRecipe
        )
        .navigationTitle(coffee.name)
        .navigationSubtitle(selectedRecipe.map { "Recipe: \($0.name)" } ?? "All Recipes")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Picker("Recipe", selection: $selectedRecipe) {
                        Text("All Recipes")
                            .tag(nil as Recipe?)
                        
                        ForEach(coffee.recipes) { recipe in
                            Text(recipe.name)
                                .tag(recipe as Recipe?)
                        }
                    }
                    .pickerStyle(.inline)
                } label: {
                    Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
                }
            }
        }
    }
}

struct BrewHistoryList: View {
    @Environment(\.sheetCoordinator) private var sheetCoordinator
    @Environment(\.alertCoordinator) private var alertCoordinator
    @Environment(\.brewUseCases) private var brewUseCases

    
    let coffee: Coffee
    let selectedRecipe: Recipe?
    
    @Query private var brews: [Brew]
    
    init(coffee: Coffee, selectedRecipe: Recipe?) {
        self.coffee = coffee
        self.selectedRecipe = selectedRecipe
        
        let coffeeID = coffee.persistentModelID
        let recipeID = selectedRecipe?.persistentModelID
        
        let predicate: Predicate<Brew>
        if let recipeID {
            predicate = #Predicate<Brew> { brew in
                brew.coffee?.persistentModelID == coffeeID && brew.recipe?.persistentModelID == recipeID
            }
        } else {
            predicate = #Predicate<Brew> { brew in
                brew.coffee?.persistentModelID == coffeeID
            }
        }
        
        _brews = Query(filter: predicate, sort: \Brew.date, order: .reverse)
    }
    
    var body: some View {
        List(brews) { brew in
            VStack(alignment: .leading, spacing: 8) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(brew.recipe?.name ?? "Unknown Recipe")
                        .font(.headline)
                    
                    // Date and Rating
                    HStack {
                        Text(brew.date, format: .dateTime)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text(brew.rating == .thumbsUp ? "👍" : "👎")
                            .font(.title3)
                    }
                }
                
                // Taste with visual indicator
                VStack(alignment: .leading, spacing: 4) {
                    // Taste scale bar
                    HStack(spacing: 4) {
                        ForEach(1...5, id: \.self) { value in
                            RoundedRectangle(cornerRadius: 2)
                                .fill(value == brew.taste ? Color.accentColor : Color.gray.opacity(0.3))
                                .frame(height: 6)
                        }
                    }
                    
                    HStack {
                        Text("Taste:")
                            .fontWeight(.medium)
                        Text(brew.tasteDescription.description)
                            .foregroundStyle(.secondary)
                    }
                }

                // Clarity with visual indicator
                VStack(alignment: .leading, spacing: 4) {
                    // Clarity scale bar
                    HStack(spacing: 4) {
                        ForEach(1...5, id: \.self) { value in
                            RoundedRectangle(cornerRadius: 2)
                                .fill(value == brew.clarityDescription.rawValue ? Color.accentColor : Color.gray.opacity(0.3))
                                .frame(height: 6)
                        }
                    }
                    
                    HStack {
                        Text("Clarity:")
                            .fontWeight(.medium)
                        Text(brew.clarityDescription.description)
                            .foregroundStyle(.secondary)
                    }
                    
                    Divider()
                }
                
                // Brew parameters
                BrewSummaryGrid(summary: BrewSummary(brew: brew))
            }
            .swipeActions(edge: .leading) {
                Button {
                    if let recipe = brew.recipe {
                        let request = CalibrateRecipeRequest(
                            recipe: recipe,
                            temperature: brew.temperature,
                            grindSetting: brew.grindSetting,
                            extractionTime: brew.extractionTime,
                            amountBeans: brew.amountCoffee,
                            output: brew.output
                        )
                        
                        sheetCoordinator.present(.confirmRecipeCalibration(recipe, request))
                    }
                } label: {
                    Label("Calibrate Recipe", systemImage: CJSymbol.Action.calibrate)
                }
            }
            .swipeActions(edge: .trailing) {
                Button(role: .destructive) {
                    do {
                        try brewUseCases.delete(brew)
                    } catch {
                        alertCoordinator.show(error)
                    }
                }
            }
            .padding(.vertical, 4)
        }
    }
}


#Preview(traits: .modifier(SampleDataModifier())) {
    @Previewable @Query(filter: #Predicate<Coffee> { coffee in
        coffee.recipes.count > 0
    }) var coffees: [Coffee]

    
    NavigationStack {
        BrewHistoryView(coffee: coffees.first!)
    }
}
