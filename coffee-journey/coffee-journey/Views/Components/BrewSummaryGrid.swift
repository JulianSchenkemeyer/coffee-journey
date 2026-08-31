//
//  BrewSummaryGrid.swift
//  coffee-journey
//

import SwiftUI


struct BrewSummaryGrid: View {
    let summary: BrewSummary

    private let columns = [GridItem(.flexible(), alignment: .leading), GridItem(.flexible(), alignment: .leading)]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            grid(summary.parameterRows)

            Divider()

            grid(summary.metricRows)
        }
        .font(.subheadline)
    }

    private func grid(_ rows: [SummaryRow]) -> some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: 8) {
            ForEach(rows) { row in
                HStack(spacing: 6) {
                    Image(systemName: row.symbol)
                        .frame(width: 20)
                    Text(row.label)
                        .fontWeight(.medium)
                    Text(row.value)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}


private struct SummaryRow: Identifiable {
    let id: String
    let symbol: String
    let label: LocalizedStringKey
    let value: String
}

// Shown instead of a metric that cannot be derived, so the row count stays stable.
private let missingValue = "–"

private extension BrewSummary {
    var parameterRows: [SummaryRow] {
        [
            SummaryRow(id: "coffee",
                       symbol: CJSymbol.BrewParameter.coffee,
                       label: "Coffee:",
                       value: "\(amountCoffee.formatted(.number.precision(.fractionLength(1)))) \(RecipeConstants.Beans.unit)"),
            SummaryRow(id: "grind",
                       symbol: CJSymbol.BrewParameter.grind,
                       label: "Grind:",
                       value: grindSetting.formatted(.number.precision(.fractionLength(0)))),
            SummaryRow(id: "temperature",
                       symbol: CJSymbol.BrewParameter.temperature,
                       label: "Temp:",
                       value: "\(temperature.formatted(.number)) \(RecipeConstants.Temperature.unit)"),
            SummaryRow(id: "time",
                       symbol: CJSymbol.BrewParameter.time,
                       label: "Time:",
                       value: "\(extractionTime.formatted(.number)) \(RecipeConstants.ExtractionTime.unit)"),
            SummaryRow(id: "output",
                       symbol: CJSymbol.BrewParameter.output,
                       label: "Output:",
                       value: "\(output.formatted(.number.precision(.fractionLength(1)))) \(RecipeConstants.Output.unit)")
        ]
    }

    var metricRows: [SummaryRow] {
        [
            SummaryRow(id: "ratio",
                       symbol: CJSymbol.BrewParameter.ratio,
                       label: "Ratio:",
                       value: ratio.map { "1:\($0.formatted(.number.precision(.fractionLength(1))))" } ?? missingValue),
            SummaryRow(id: "flowRate",
                       symbol: CJSymbol.BrewParameter.flowRate,
                       label: "Flow Rate:",
                       value: flowRate.map { "\($0.formatted(.number.precision(.fractionLength(2)))) \(RecipeConstants.FlowRate.unit)" } ?? missingValue)
        ]
    }
}


#Preview {
    Form {
        Section("Summary") {
            BrewSummaryGrid(summary: BrewSummary(
                amountCoffee: 18.0,
                grindSetting: 12.0,
                temperature: 96,
                extractionTime: 30,
                output: 36.0
            ))
        }

        Section("Missing Metrics") {
            BrewSummaryGrid(summary: BrewSummary(
                amountCoffee: 0.0,
                grindSetting: 12.0,
                temperature: 96,
                extractionTime: 0,
                output: 36.0
            ))
        }
    }
}
