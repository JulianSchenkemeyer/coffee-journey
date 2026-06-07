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
    
    let coffee: Coffee

    @State private var showDeleteConfirmation = false
    @State private var selectedRecipe: Recipe?
    
    var amountLeft: String {
        return coffee.amountLeft.formatted(.number.precision(.fractionLength(0...1)))
    }
    
    var amount: String {
        return coffee.amount.formatted(.number.precision(.fractionLength(0...1)))
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
                
                RecipeCardGalleryView(coffee: coffee, recipes: coffee.recipes, selectedRecipe: $selectedRecipe)

                VStack(alignment: .leading, spacing: 16) {
                    Text(selectedRecipe.map { "Filtered by \($0.name)" } ?? "All Brews")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    BrewTasteDistributionChartView(brews: selectedRecipe?.brews ?? coffee.brews)
                }
            }
            .padding(.horizontal, 24)
        }
        .navigationTitle(coffee.name)
        .navigationSubtitle(coffee.roaster)
        .toolbarBackground(.hidden, for: .navigationBar)
        .onChange(of: coffee.recipes) {
            if let selected = selectedRecipe, !coffee.recipes.contains(where: { $0.id == selected.id }) {
                selectedRecipe = nil
            }
        }
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
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button("Refill", systemImage: CJSymbol.Action.refill) {
                    sheetCoordinator.present(.refill(coffee))
                }
                Button("Brew", systemImage: CJSymbol.Action.brew) {
                    sheetCoordinator.present(.brew(coffee))
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Menu("Actions", systemImage: "ellipsis") {
                    Button("Edit Coffee", systemImage: CJSymbol.Action.edit) {
                        sheetCoordinator.present(.addCoffee(coffee))
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

