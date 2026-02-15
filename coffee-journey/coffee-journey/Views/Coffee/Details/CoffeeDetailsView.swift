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
    @Environment(\.router) private var router
    
    let coffee: Coffee
    
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
                
                RecipeCardGalleryView(coffee: coffee, recipes: coffee.recipes)
                
                BrewTasteDistributionChartView(brews: coffee.brews)
            }
            .padding(.horizontal, 24)
        }
        .navigationTitle(coffee.name)
        .navigationSubtitle(coffee.roaster)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button("Refill", systemImage: "arrow.trianglehead.clockwise") {
                    sheetCoordinator.present(.refill(coffee))
                }
                Button("Brew", systemImage: "cup.and.heat.waves.fill") {
                    sheetCoordinator.present(.brew(coffee))
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Menu("Actions", systemImage: "ellipsis") {
                    Button("Edit", systemImage: "pencil") {
                        sheetCoordinator.present(.addCoffee(coffee))
                    }
                    
                    Button("Brew History", systemImage: "square.stack.fill") {
                        router.navigate(to: .brewHistory(coffee, nil))
                    }
                    
                    Divider()
                    
                    Button("Delete", systemImage: "trash", role: .destructive) {
                        
                    }
                }
            }
        }
    }
}


#Preview {
    NavigationStack {
        CoffeeDetailsView(coffee: .Mock.espresso)
    }
}

