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
                VStack(spacing: 16) {
                    Image(systemName: "cup.and.saucer.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(.secondary)
                    
                    Text("\(amountLeft) / \(amount) g")
                        .font(.title2)
                        .monospaced()
                        .fontWeight(.semibold)
                    
                    Divider()
                        .padding(.horizontal)
                    
                    Grid(alignment: .leading, horizontalSpacing: 20, verticalSpacing: 12) {
                        GridRow {
                            Text("Roasted")
                                .foregroundStyle(.secondary)
                            Spacer()
                            if let roastDate = coffee.newestRefill?.roastDate {
                                Text(roastDate, format: .dateTime.day().month().year())
                            } else {
                                Text("—")
                            }
                        }
                        
                        GridRow {
                            Text("Refilled")
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text(coffee.lastRefill, format: .dateTime.day().month().year())
                        }
                        
                        GridRow {
                            Text("Brews")
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text(coffee.totalBrews, format: .number)
                                .monospaced()
                        }
                        
                        GridRow {
                            Text("Rating")
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text(coffee.rating, format: .number.precision(.fractionLength(0...1)))
                                .monospaced()
                        }
                    }
                    .font(.callout)
                    
                    Divider()
                        .padding(.horizontal)
                    
                    // Notes section
                    VStack(alignment: .leading, spacing: 12) {
                        Text(coffee.notes)
                            .font(.body)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 12)
                }
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
                    // Recipes section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Recipes")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 24)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(coffee.recipes) { recipe in
                                    RecipeCardView(recipe: recipe)
                                        .frame(width: 300)
                                }
                                
                                AddRecipeCardButtonView {
                                    print("Add recipe")
                                }
                                .frame(width: 300)
                            }
                            .scrollTargetLayout()
                            .padding(.horizontal, 20)
                        }
                        .scrollTargetBehavior(.viewAligned)
                    }
                    .padding(.vertical, 12)
                    
                    // Brew taste distribution chart
                    BrewTasteDistributionChartView(brews: coffee.brews)
                        .padding(24)
                }
                .background {
                    Color(UIColor.systemBackground)
                        .ignoresSafeArea()
                }
        }
        .background(Color(UIColor.systemGray6))
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

