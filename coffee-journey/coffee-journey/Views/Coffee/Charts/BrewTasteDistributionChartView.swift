//
//  BrewRatingChartView.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 11.01.26.
//

import SwiftUI
import SwiftData
import Charts


struct BrewTasteDistributionChartView: View {
    enum Options: String, CaseIterable, Identifiable {
        case Temperature
        case AmountCoffee
        case GrindSize
        case BrewTime
        case Output
        case BeanAge
        
        
        var id: String { self.rawValue }
        
        var label: String {
            switch self {
            case .Temperature: return "Temperature"
            case .AmountCoffee: return "Amount of Coffee"
            case .GrindSize: return "Grind Size"
            case .BrewTime: return "Brew Time"
            case .Output: return "Output"
            case .BeanAge: return "Bean Age"
            }
        }
        
        func value(for brew: Brew) -> Double {
            switch self {
            case .Temperature: return Double(brew.temperature)
            case .AmountCoffee: return brew.amountCoffee
            case .GrindSize: return brew.grindSetting
            case .BrewTime: return Double(brew.extractionTime)
            case .Output: return brew.output
            case .BeanAge: return Double(brew.beanAge ?? 0)
            }
        }
        
        func unit() -> String {
            switch self {
            case .Temperature: return "°C"
            case .AmountCoffee: return "g"
            case .GrindSize: return ""
            case .BrewTime: return "s"
            case .Output: return "g"
            case .BeanAge: return "days"
            }
        }
    }
    
    @State private var option = Options.AmountCoffee

    let brews: [Brew]

    /// Returns a stable spread offset in -0.3...0.3 for a given brew.
    ///
    /// Using `Double.random` here causes points to jump every time the view
    /// re-renders (e.g. when a context menu opens). Instead we derive a
    /// deterministic value from the brew's persistent ID so the offset is
    /// consistent across renders while still spreading points apart visually.
    ///
    /// The formula maps the ID hash → 0...600 via modulo, then scales to
    /// 0.0...0.6 and shifts to -0.3...0.3. 601 = (0.3 - (-0.3)) * 1000 + 1.
    private func spreadOffset(for brew: Brew) -> Double {
        Double(UInt(bitPattern: brew.persistentModelID.hashValue) % 601) / 1000.0 - 0.3
    }
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 14) {
            Picker("Variable", selection: $option) {
                ForEach(Options.allCases) { option in
                    Text(option.label).tag(option)
                }
            }
            .pickerStyle(.menu)
            
            Chart(brews) { brew in
                PointMark(
                    x: .value(
                        "Taste",
                        Double(brew.taste) + spreadOffset(for: brew)
                    ) ,
                    y: .value(
                        option.label,
                        option.value(for: brew)
                    )
                )
                .foregroundStyle(by: .value("Brew Rating", brew.rating.rawValue))
            }
            .chartForegroundStyleScale([
                "Good": .blue.opacity(0.4),
                "Bad": .red.opacity(0.2)
            ])
            .chartXScale(domain: 0...6)
            .chartYScale(domain: {
                let values = brews.map { option.value(for: $0) }
                let min = max((values.min() ?? 0) - 1, 0)
                let max = (values.max()  ?? 1) + 1
                
                return min...(max)
            }())
            .chartYAxis {
                AxisMarks { value in
                    if let number = value.as(Double.self) {
                        AxisValueLabel("\(number, format: .number) \(option.unit())")
                    }
                }
            }
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
}


#Preview {
    BrewTasteDistributionChartView(brews: Brew.Mock.brews)
}
