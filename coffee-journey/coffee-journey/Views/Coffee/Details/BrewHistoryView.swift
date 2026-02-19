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
                // Date and Rating
                HStack {
                    Text(brew.date, format: .dateTime)
                        .font(.headline)
                    Spacer()
                    Text(brew.rating == .thumbsUp ? "👍" : "👎")
                        .font(.title3)
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
                    
                    Divider()
                }
                
                // Brew parameters
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 0) {
                        // Left column
                        HStack(spacing: 6) {
                            Image(systemName: "scalemass.fill")
                                .foregroundStyle(.primary)
                                .frame(width: 20)
                            Text("Coffee:")
                                .fontWeight(.medium)
                            Text("\(brew.amountCoffee.formatted())g")
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // Right column
                        HStack(spacing: 6) {
                            Image(systemName: "dial.high.fill")
                                .foregroundStyle(.primary)
                                .frame(width: 20)
                            Text("Grind:")
                                .fontWeight(.medium)
                            Text("\(brew.grindSetting.formatted())")
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    HStack(spacing: 0) {
                        // Left column
                        HStack(spacing: 6) {
                            Image(systemName: "thermometer.medium")
                                .foregroundStyle(.primary)
                                .frame(width: 20)
                            Text("Temp:")
                                .fontWeight(.medium)
                            Text("\(brew.waterTemperature.formatted())°C")
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // Right column
                        HStack(spacing: 6) {
                            Image(systemName: "timer")
                                .foregroundStyle(.primary)
                                .frame(width: 20)
                            Text("Time:")
                                .fontWeight(.medium)
                            Text("\(brew.extractionTime)s")
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    HStack(spacing: 6) {
                        Image(systemName: "drop.fill")
                            .foregroundStyle(.primary)
                            .frame(width: 20)
                        Text("Output:")
                            .fontWeight(.medium)
                        Text("\(brew.output.formatted())ml")
                            .foregroundStyle(.secondary)
                    }
                }
                .font(.subheadline)
            }
            .swipeActions(edge: .leading) {
                Button {
                    if let recipe = brew.recipe {
                        sheetCoordinator.present(.confirmRecipeCalibration(recipe, brew))
                    }
                } label: {
                    Label("Calibrate Recipe", systemImage: "target")
                }
            }
            .swipeActions(edge: .trailing) {
                Button(role: .destructive) {
                    try! brewUseCases.delete(brew)
                }
            }
            .padding(.vertical, 4)
        }
    }
}


#Preview {
    let mockData = Coffee.Mock.espresso
    mockData.brews = Brew.Mock.brews
    
    return PreviewUseCaseEnvironment {
        NavigationStack {
            BrewHistoryView(coffee: mockData)
        }
    }
}
