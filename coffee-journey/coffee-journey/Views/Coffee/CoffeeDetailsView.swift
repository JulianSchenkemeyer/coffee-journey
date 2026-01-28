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
                Image(systemName: "cup.and.saucer.fill")
                    .resizable()
                    .frame(width: 140, height: 140)
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
                        Text("Last Refill: ")
                            .fontWeight(.semibold)
                        Spacer()
                        Text(coffee.lastRefill, format: .dateTime.day().month().year())
                    }
                    
                    HStack {
                        Text("Rating: ")
                            .fontWeight(.semibold)
                        Spacer()
                        Text(coffee.rating, format: .number.precision(.fractionLength(0...1)))
                            .monospaced()
                    }
                }
                .padding(24)
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
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(24)
            .navigationTitle(coffee.name)
            .navigationSubtitle(coffee.roaster)
        }
    }
}


#Preview {
    NavigationStack {
        CoffeeDetailsView(coffee: .Mock.espresso)
    }
}

