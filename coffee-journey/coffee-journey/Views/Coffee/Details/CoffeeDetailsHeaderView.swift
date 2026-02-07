//
//  CoffeeDetailsHeaderView.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 07.02.26.
//
import Foundation
import SwiftUI


struct CoffeeDetailsHeaderView: View {
    var amount: String
    var amountLeft: String
    var roastDate: Date?
    var lastRefill: Date
    var totalBrews: Int
    var rating: Double
    var notes: String?
    
    
    
    var body: some View {
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
                    if let roastDate {
                        Text(roastDate, format: .dateTime.day().month().year())
                    } else {
                        Text("—")
                    }
                }
                
                GridRow {
                    Text("Refilled")
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text(lastRefill, format: .dateTime.day().month().year())
                }
                
                GridRow {
                    Text("Brews")
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text(totalBrews, format: .number)
                        .monospaced()
                }
                
                GridRow {
                    Text("Rating")
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text(rating, format: .number.precision(.fractionLength(0...1)))
                        .monospaced()
                }
            }
            .font(.callout)
            
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
    VStack {
        CoffeeDetailsHeaderView(
            amount: "125",
            amountLeft: "250",
            roastDate: .twoWeekAgo,
            lastRefill: .oneWeekAgo,
            totalBrews: 7,
            rating: 4,
            notes: "chocolate, red fruits"
        )
        
        Spacer()
            .background { Color.blue }
        
        Text("Content goes here.")
    }
    .padding()
}
