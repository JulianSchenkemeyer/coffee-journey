//
//  BrewRatingChartView.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 11.01.26.
//

import Foundation
import SwiftUI
import Charts


struct BrewTasteDistributionChartView: View {
    let brews: [Brew]
    
    var body: some View {
        Chart(brews) { brew in
            BarMark(x: .value("Taste", brew.taste), y: .value("Amount", 1), width: .fixed(40))
        }
        .chartXScale(domain: 0...6)
        .chartYAxis(.hidden)
        .chartXAxis {
            AxisMarks(preset: .aligned, values: [1, 3, 5]) { value in
                switch value.as(Int.self) {
                case 1:
                    AxisValueLabel("Sour")
                case 3:
                    AxisValueLabel("Balanced")
                case 5:
                    AxisValueLabel("Bitter")
                default:
                    AxisValueLabel(" ")
                }
            }
        }
        .chartLegend(.hidden)
        .frame(height: 160)
    }
}


#Preview {
    BrewTasteDistributionChartView(brews: Brew.Mock.brews)
}

