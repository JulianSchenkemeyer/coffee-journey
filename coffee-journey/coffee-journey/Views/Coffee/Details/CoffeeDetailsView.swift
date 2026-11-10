//
//  CoffeeDetails.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 24.11.25.
//

import SwiftUI
import SwiftData


struct CoffeeDetailsView: View {
    @Environment(\.sheetCoordinator) private var sheetCoordinator
    @Environment(\.alertCoordinator) private var alertCoordinator
    @Environment(\.router) private var router
    @Environment(\.coffeeUseCases) private var coffeeUseCases
    @Environment(\.sheetNamespace) private var sheetNamespace
    /// Previews only — the environment value is nil outside SheetCoordinatorView.
    @Namespace private var fallbackSheetNamespace
    
    let coffee: Coffee

    @State private var showDeleteConfirmation = false
    
    var amountLeft: String {
        coffee.amountLeft.formatted(.number.precision(.fractionLength(0...1)))
    }

    var amount: String {
        coffee.amount.formatted(.number.precision(.fractionLength(0...1)))
    }

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 24) {
                CoffeeDetailsHeaderView(
                    amount: amount,
                    amountLeft: amountLeft,
                    roastDate: coffee.newestRefill?.roastDate,
                    lastRefill: coffee.lastRefill,
                    totalBrews: coffee.totalBrews,
                    rating: coffee.rating,
                    notes: coffee.notes
                )
                .frame(maxWidth: .infinity)
                .padding(.top, 24)
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Recipes")
                            .font(.headline)
                            .foregroundStyle(.secondary)

                        Spacer()

                        if coffee.recipes.count > 3 {
                            Button("See All") {
                                router.navigate(to: .recipes(coffee))
                            }
                        }
                    }

                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(coffee.recentRecipes.prefix(3)) { recipe in
                            RouteLink(.recipeDetails(coffee, recipe)) {
                                HStack {
                                    RecipeRow(recipe: recipe)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.footnote.weight(.semibold))
                                        .foregroundStyle(.tertiary)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .contentShape(.rect)
                            }
                            .buttonStyle(.plain)
                            .recipeActions(coffee: coffee, recipe: recipe)

                            Divider()
                                .padding(.leading, 16)
                        }

                        Button {
                            sheetCoordinator.present(.editRecipe(coffee, nil), from: .addRecipe(coffee))
                        } label: {
                            Label("Add Recipe", systemImage: CJSymbol.Action.add)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .contentShape(.rect)
                        }
                        .sheetZoomSource(.addRecipe(coffee))
                    }
                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
                }

                BrewTasteDistributionChartView(brews: coffee.brews)
            }
            .padding(.horizontal, 24)
        }
        .navigationTitle(coffee.name)
        .navigationSubtitle(coffee.roaster)
        .toolbarBackground(.hidden, for: .navigationBar)
        .alert("Delete \(coffee.name)?", isPresented: $showDeleteConfirmation) {
            Button("Delete", role: .destructive) {
                do {
                    try coffeeUseCases.delete(coffee)
                    router.navigateBack()
                } catch {
                    alertCoordinator.show(error)
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will permanently delete this coffee along with all its brews and recipes.")
        }
        .toolbar {
            // Split out of a ToolbarItemGroup so each button can carry its own zoom anchor.
            ToolbarItem(placement: .topBarTrailing) {
                Button("Refill", systemImage: CJSymbol.Action.refill) {
                    sheetCoordinator.present(.refill(coffee), from: .refillCoffee(coffee))
                }
            }
            .sheetZoomSource(.refillCoffee(coffee), in: sheetNamespace ?? fallbackSheetNamespace)
            
            ToolbarItem(placement: .topBarTrailing) {
                Button("Brew", systemImage: CJSymbol.Action.brew) {
                    sheetCoordinator.present(.brew(coffee, nil), from: .brewCoffee(coffee))
                }
            }
            .sheetZoomSource(.brewCoffee(coffee), in: sheetNamespace ?? fallbackSheetNamespace)
            
            ToolbarItem(placement: .topBarTrailing) {
                Menu("Actions", systemImage: "ellipsis") {
                    Button("Edit Coffee", systemImage: CJSymbol.Action.edit) {
                        router.navigate(to: .editCoffee(coffee))
                    }
                    
                    Button("Brew History", systemImage: CJSymbol.Navigation.brewHistory) {
                        router.navigate(to: .brewHistory(coffee, nil))
                    }
                    
                    Divider()
                    
                    Button("Empty Beans", systemImage: CJSymbol.Action.clear) {
                        sheetCoordinator.present(.confirmEmptying(coffee))
                    }
                    
                    Button("Delete", systemImage: CJSymbol.Action.delete, role: .destructive) {
                        showDeleteConfirmation = true
                    }
                }
            }
        }
    }
}


#Preview(traits: .modifier(SampleDataModifier())) {
    NavigationStack {
        CoffeeDetailsView(coffee: .Mock.espresso)
    }
}

#Preview("0 Recipes", traits: .modifier(SampleDataModifier())) {
    NavigationStack {
        CoffeeDetailsView(coffee: .previewCoffee(recipeCount: 0))
    }
}

#Preview("1 Recipe", traits: .modifier(SampleDataModifier())) {
    NavigationStack {
        CoffeeDetailsView(coffee: .previewCoffee(recipeCount: 1))
    }
}

#Preview("3 Recipes", traits: .modifier(SampleDataModifier())) {
    NavigationStack {
        CoffeeDetailsView(coffee: .previewCoffee(recipeCount: 3))
    }
}

#Preview("5 Recipes", traits: .modifier(SampleDataModifier())) {
    NavigationStack {
        CoffeeDetailsView(coffee: .previewCoffee(recipeCount: 5))
    }
}

private extension Coffee {
    // A coffee with `recipeCount` recipes on distinct grinders, used on consecutive days.
    @MainActor static func previewCoffee(recipeCount: Int) -> Coffee {
        let brewer = Equipment(name: "Picopresso", brand: "Wacaco", type: EquipmentType.machine.rawValue, notes: "")
        let recipes = (0..<recipeCount).map { index in
            let grinder = Equipment(name: "Grinder \(index + 1)", brand: "Generic", type: EquipmentType.grinder.rawValue, notes: "")
            let recipe = Recipe(temperature: 94, grindSetting: 10 + Double(index), extractionTime: 30, input: 18, output: 36, brewer: brewer, grinder: grinder)
            recipe.lastUsed = DateHelper.daysAgo(index, hour: 8, minute: 0)
            return recipe
        }
        return Coffee(
            name: "Preview Coffee",
            roaster: "Preview Roaster",
            roastCategory: RoastCategory.medium.rawValue,
            amount: 250,
            amountLeft: 180,
            lastRefill: .now,
            brews: [],
            recipes: recipes,
            totalBrews: 0,
            brewsSinceRefill: 0,
            roastDate: .now,
            rating: 0,
            notes: ""
        )
    }
}

