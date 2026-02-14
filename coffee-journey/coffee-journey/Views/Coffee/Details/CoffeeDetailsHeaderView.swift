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
        VStack {
            Text("\(amountLeft) / \(amount) g")
                .font(.title2)
                .monospaced()
                .fontWeight(.semibold)
            
            Divider()
                .padding(.horizontal)
            
            Grid(alignment: .leading, horizontalSpacing: 0, verticalSpacing: 12) {
                GridRow {
                    Label("Roasted", systemImage: "flame.fill")
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
                    Label("Refilled", systemImage: "arrow.trianglehead.clockwise")
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                        .gridCellUnsizedAxes(.vertical)
                    
                    Text(lastRefill, format: .dateTime.day().month().year())
                }
                
                GridRow {
                    Label("Brew", systemImage: "cup.and.heat.waves.fill")
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                        .gridCellUnsizedAxes(.vertical)
                    
                    Text(totalBrews, format: .number)
                        .monospaced()
                }
                
                GridRow {
                    Label("Rating", systemImage: "star.fill")
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
