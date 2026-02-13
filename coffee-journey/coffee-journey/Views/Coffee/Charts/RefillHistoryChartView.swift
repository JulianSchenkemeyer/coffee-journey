//
//  RefillHistoryChartView.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 12.02.26.
//

import Foundation
import SwiftUI
import Charts


struct RefillHistoryChartView: View {
    let refills: [Refill]
    @State private var selectedDate: Date?
    
    var body: some View {
        Chart(refills) { refill in
            BarMark(
                x: .value("Date", refill.date, unit: .day),
                y: .value("Amount", refill.amount)
            )
        }
        .chartXAxis {
            AxisMarks(values: .automatic) { _ in
                AxisValueLabel(format: .dateTime.month().day())
            }
        }
        .chartYAxis(.hidden)
        .chartXSelection(value: $selectedDate)
        .overlay(alignment: .top) {
            if let selectedDate = selectedDate,
               let selectedRefill = refills.first(where: { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(selectedRefill.date, format: .dateTime.month().day().year())
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("\(Int(selectedRefill.amount))g")
                        .font(.headline)
                }
                .padding(8)
                .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8))
                .padding(.top, 8)
            }
        }
        .frame(height: 100)
    }
}


#Preview {
    RefillHistoryChartView(refills: [
        Refill(amount: 250, roastDate: Date(), date: Date().addingTimeInterval(-2 * 24 * 60 * 60)),
        Refill(amount: 500, roastDate: Date(), date: Date().addingTimeInterval(-14 * 24 * 60 * 60)),
        Refill(amount: 300, roastDate: Date(), date: Date().addingTimeInterval(-21 * 24 * 60 * 60)),
        Refill(amount: 450, roastDate: Date(), date: Date().addingTimeInterval(-35 * 24 * 60 * 60))
    ])
}
