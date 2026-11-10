//
//  BeanAgeChartView.swift
//  coffee-journey
//

import SwiftUI
import Charts
import SwiftData


// Good vs. bad brews per week off roast, to show when a coffee tastes best.
struct BeanAgeChartView: View {
    // Below this, a handful of brews would read as a trend.
    static let minimumBrews = 5

    let curve: RestCurve
    var currentBeanAge: Int?

    var body: some View {
        if curve.brewCount < Self.minimumBrews {
            Text("Brew a few more times to see when this coffee tastes best.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, minHeight: 120)
        } else {
            // Only marked when today falls into a week that has brews; a long-stale coffee would
            // otherwise stretch the axis over many empty weeks.
            let todayBucket = currentBeanAge.flatMap { age in
                curve.buckets.first { $0.index == RestCurve.bucketIndex(forDay: age) }
            }
            let maxTotal = curve.buckets.map(\.total).max() ?? 0

            Chart {
                ForEach(curve.buckets) { bucket in
                    // Empty segments are skipped; the x scale below keeps empty weeks on the axis.
                    if bucket.good > 0 {
                        BarMark(x: .value("Days off Roast", label(for: bucket)), y: .value("Brews", bucket.good))
                            .foregroundStyle(by: .value("Rating", BrewRating.thumbsUp.description))
                    }
                    if bucket.bad > 0 {
                        BarMark(x: .value("Days off Roast", label(for: bucket)), y: .value("Brews", bucket.bad))
                            .foregroundStyle(by: .value("Rating", BrewRating.thumbsDown.description))
                    }
                }

                if let todayBucket {
                    RuleMark(x: .value("Days off Roast", label(for: todayBucket)))
                        .foregroundStyle(.secondary)
                        .lineStyle(StrokeStyle(lineWidth: 1, dash: [4, 3]))
                        .annotation(position: .top) {
                            Text("Today")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                }
            }
            .chartXScale(domain: curve.buckets.map { label(for: $0) })
            // Whole-number counts, not percentages, so small samples aren't overstated.
            .chartYAxis {
                AxisMarks(values: .stride(by: Double(Swift.max(1, (maxTotal + 3) / 4)))) { value in
                    AxisGridLine()
                    AxisValueLabel {
                        if let count = value.as(Double.self) {
                            Text(Int(count), format: .number)
                        }
                    }
                }
            }
            .chartForegroundStyleScale([
                BrewRating.thumbsUp.description: Color.blue,
                BrewRating.thumbsDown.description: Color.red.opacity(0.7)
            ])
            .chartLegend(position: .top, alignment: .leading)
            .chartXAxisLabel("Days off roast", alignment: .center)
            .frame(height: 200)
            // Charts merges stacked segments into one element with a generic summary, so VoiceOver
            // gets one line per week instead.
            .accessibilityRepresentation {
                VStack {
                    ForEach(curve.buckets) { bucket in
                        Text("Days \(bucket.firstDay) to \(bucket.lastDay): ^[\(bucket.good) good brew](inflect: true), ^[\(bucket.bad) bad brew](inflect: true)")
                    }
                    if todayBucket != nil, let currentBeanAge {
                        Text("Today is day \(currentBeanAge) off roast")
                    }
                }
            }
        }
    }

    private func label(for bucket: RestCurve.Bucket) -> String {
        "\(bucket.firstDay)–\(bucket.lastDay)"
    }
}


#Preview(traits: .modifier(SampleDataModifier())) {
    @Previewable @Query var coffees: [Coffee]
    let coffee = coffees.max { $0.brews.count < $1.brews.count }

    Form {
        Section("Several Weeks") {
            if let coffee {
                BeanAgeChartView(curve: RestCurve(brews: coffee.brews), currentBeanAge: coffee.beanAge)
            }
        }

        Section("Too Few Brews") {
            BeanAgeChartView(curve: RestCurve(brews: []))
        }
    }
}
