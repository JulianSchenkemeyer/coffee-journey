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
            VStack(spacing: 24) {
                HStack(alignment: .center, spacing: 14) {
                    Image(systemName: "cup.and.saucer.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .padding(36)
                        .background {
                            Color.gray.opacity(0.3)
                                .clipShape(.circle)
                        }
                    
                    
                    VStack(spacing: 12) {
                        Text("\(amountLeft) / \(amount) g")
                            .monospaced()
                            .fontWeight(.semibold)
                        
                        HStack {
                            Text("Roasted: ")
                                .fontWeight(.semibold)
                            Spacer()
                            if let roastDate = coffee.newestRefill?.roastDate {
                                Text(roastDate, format: .dateTime.day().month().year())
                            } else {
                                Text(" - ")
                            }
                            
                        }
                        .font(.callout)
                        
                        HStack {
                            Text("Refilled: ")
                                .fontWeight(.semibold)
                            Spacer()
                            Text(coffee.lastRefill, format: .dateTime.day().month().year())
                        }
                        .font(.callout)
                        
                        HStack {
                            Text("Brews: ")
                                .fontWeight(.semibold)
                            Spacer()
                            Text(coffee.totalBrews, format: .number)
                                .monospaced()
                        }
                        .font(.callout)
                        
                        HStack {
                            Text("Rating: ")
                                .fontWeight(.semibold)
                            Spacer()
                            Text(coffee.rating, format: .number.precision(.fractionLength(0...1)))
                                .monospaced()
                        }
                        .font(.callout)
                    }
                }
                .padding(12)
                .glassEffect(in: .rect(cornerRadius: 24.0))
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Notes")
                        .fontWeight(.semibold)
                    
                    Text(coffee.notes)
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(24)
                .glassEffect(in: .rect(cornerRadius: 24.0))
                
                BrewTasteDistributionChartView(brews: coffee.brews)
                    .padding(24)
                    .glassEffect(in: .rect(cornerRadius: 24.0))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(24)
            .navigationTitle(coffee.name)
            .navigationSubtitle(coffee.roaster)
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Refill", systemImage: "arrow.trianglehead.clockwise") {
                        print("refill")
                    }
                    Button("Brew", systemImage: "cup.and.heat.waves.fill") {
                        print("brew")
                    }
                }
                
                ToolbarSpacer(.flexible, placement: .topBarTrailing)
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Edit", systemImage: "pencil") {
                        print("edit")
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

