//
//  CoffeeDetails.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 24.11.25.
//

import SwiftUI
import SwiftData


struct CoffeeDetailsView: View {
    let coffee: Coffee
    
    var amountLeft: String {
        return coffee.amountLeft.formatted(.number.precision(.fractionLength(0...1)))
    }
    
    var amount: String {
        return coffee.amount.formatted(.number.precision(.fractionLength(0...1)))
    }
    
    var body: some View {
        ScrollView {
            VStack {
                // Hero header section with background
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
                .padding(.horizontal, 24)
                .padding(.top, 24)
                .padding(.bottom, 32)
                .background {
                    Color(UIColor.systemGray6)
                }
                .padding(.bottom, 12)
            }
            // Content sections on white background
            VStack(spacing: 20) {
                RecipeCardGalleryView(recipes: coffee.recipes)
                    .padding(.vertical, 12)
                
                // Brew taste distribution chart
                BrewTasteDistributionChartView(brews: coffee.brews)
                    .padding(24)
            }
            .background {
                Color(UIColor.systemBackground)
            }
        }
        .navigationTitle(coffee.name)
        .navigationSubtitle(coffee.roaster)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button("Refill", systemImage: "arrow.trianglehead.clockwise") {
                    print("refill")
                }
                Button("Brew", systemImage: "cup.and.heat.waves.fill") {
                    print("brew")
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button("Edit", systemImage: "pencil") {
                    print("edit")
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

