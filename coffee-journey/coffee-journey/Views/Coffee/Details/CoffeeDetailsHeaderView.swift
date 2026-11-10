//
//  CoffeeDetailsHeaderView.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 07.02.26.
//
import Foundation
import SwiftUI
import SwiftData


struct CoffeeDetailsHeaderView: View {
    var amount: String
    var amountLeft: String
    var roastDate: Date?
    var lastRefill: Date
    var totalBrews: Int
    var rating: Double
    var notes: String?
    var forecast: SupplyForecast?
    
    
    
    var body: some View {
        VStack {
            Text("\(amountLeft) / \(amount) g")
                .font(.title2)
                .monospaced()
                .fontWeight(.semibold)

            if let forecast {
                let daysLeft = Swift.max(Int(forecast.daysLeft.rounded()), 1)
                Text("≈ ^[\(daysLeft) day](inflect: true) left · \(forecast.gramsPerDay, format: .number.precision(.fractionLength(0)))\u{00A0}g/day")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Divider()
                .padding(.horizontal)
            
            Grid(alignment: .leading, horizontalSpacing: 0, verticalSpacing: 12) {
                GridRow {
                    Label("Roasted", systemImage: CJSymbol.Coffee.roasted)
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                        .gridCellUnsizedAxes(.vertical)
                    
                    if let roastDate {
                        Text(roastDate, format: .dateTime.day().month().year())
                            .gridColumnAlignment(.trailing)
                    } else {
                        Text("—")
                            .gridColumnAlignment(.trailing)
                    }
                }
                
                GridRow {
                    Label("Refilled", systemImage: CJSymbol.Coffee.refilled)
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                        .gridCellUnsizedAxes(.vertical)
                    
                    Text(lastRefill, format: .dateTime.day().month().year())
                }
                
                GridRow {
                    Label("Brew", systemImage: CJSymbol.Coffee.brew)
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                        .gridCellUnsizedAxes(.vertical)
                    
                    Text(totalBrews, format: .number)
                        .monospaced()
                }
                
                GridRow {
                    Label("Rating", systemImage: CJSymbol.Coffee.rating)
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                        .gridCellUnsizedAxes(.vertical)
                    
                    Text(rating, format: .number.precision(.fractionLength(0...1)))
                        .monospaced()
                }
            }
            .font(.callout)
            .frame(maxWidth: .infinity)
            
            if let notes {
                Divider()
                    .padding(.horizontal)
                
                // Notes section
                VStack(alignment: .leading, spacing: 12) {
                    Text(notes)
                        .font(.body)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 12)
            }
        }
    }
}


#Preview {
    CoffeeDetailsHeaderView(
        amount: "125",
        amountLeft: "250",
        roastDate: .twoWeekAgo,
        lastRefill: .oneWeekAgo,
        totalBrews: 7,
        rating: 4,
        notes: "chocolate, red fruits"
    )
}

#Preview("Forecast", traits: .modifier(SampleDataModifier())) {
    @Previewable @Query var coffees: [Coffee]
    let coffee = coffees.max { $0.brews.count < $1.brews.count }

    // Sample brews are months old, so forecast as of the latest one.
    if let coffee, let latest = coffee.brews.map(\.date).max() {
        CoffeeDetailsHeaderView(
            amount: "250",
            amountLeft: "120",
            roastDate: .twoWeekAgo,
            lastRefill: .oneWeekAgo,
            totalBrews: coffee.brews.count,
            rating: 4,
            forecast: SupplyForecast(brews: coffee.brews, amountLeft: 120, now: latest)
        )
    }
}
