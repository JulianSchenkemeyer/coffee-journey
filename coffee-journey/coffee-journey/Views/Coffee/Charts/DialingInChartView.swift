//
//  DialingInChartView.swift
//  coffee-journey
//

import SwiftUI
import Charts


// How a recipe's brews moved toward balanced and clean, one point per brew.
struct DialingInChartView: View {
    // Below this, the line doesn't show a direction yet.
    static let minimumBrews = 3
    // Beyond this, the chart scrolls instead of squeezing the points together.
    static let visibleBrews = 15

    let progress: DialingInProgress

    @State private var selectedBrew: Double?
    // Leading edge of the visible window; shared so both rows scroll together.
    @State private var scrollPosition: Double
    // Both rows get the same label width, so their plot areas line up on the shared x axis.
    @ScaledMetric(relativeTo: .caption2) private var yLabelWidth = 56

    init(progress: DialingInProgress) {
        self.progress = progress
        _scrollPosition = State(initialValue: Self.latestWindowStart(brewCount: progress.points.count))
    }

    private struct Entry: Identifiable {
        let point: DialingInProgress.Point
        let value: Int
        let average: Double

        var id: Int { point.number }
    }

    var body: some View {
        if progress.points.count < Self.minimumBrews {
            Text("Brew this recipe a few more times to see your progress.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, minHeight: 120)
        } else {
            let tasteEntries = progress.points.map { Entry(point: $0, value: $0.taste, average: $0.tasteAverage) }
            let clarityEntries = progress.points.compactMap { point in
                point.clarity.flatMap { clarity in
                    point.clarityAverage.map { Entry(point: point, value: clarity, average: $0) }
                }
            }

            VStack(alignment: .leading, spacing: 12) {
                header

                row(tasteEntries, title: "Taste", labels: [1: "Sour", 3: "Balanced", 5: "Bitter"],
                    showsXAxis: clarityEntries.isEmpty, height: 180)

                if !clarityEntries.isEmpty {
                    row(clarityEntries, title: "Clarity", labels: [1: "Flat", 3: "Clean", 5: "Harsh"],
                        showsXAxis: true, height: 130)
                        // The taste points already read out each brew's clarity.
                        .accessibilityHidden(true)
                }
            }
            .onChange(of: progress.points.count) { _, count in
                scrollPosition = Self.latestWindowStart(brewCount: count)
            }
        }
    }

    // The selected brew's details, or the legend while nothing is selected.
    private var header: some View {
        Group {
            if let point = selectedPoint {
                Text("Brew \(point.number), \(point.date, format: .dateTime.day().month()): \(summary(of: point))")
            } else {
                HStack(spacing: 12) {
                    Label("Good", systemImage: "circle.fill")
                        .labelStyle(LegendLabelStyle(color: .blue))
                    Label("Bad", systemImage: "circle")
                        .labelStyle(LegendLabelStyle(color: .red))
                    Label("Refill", systemImage: "line.diagonal")
                        .labelStyle(LegendLabelStyle(color: .secondary))
                }
                .accessibilityHidden(true)
            }
        }
        .font(.caption)
        .foregroundStyle(.secondary)
    }

    private func row(_ entries: [Entry], title: String, labels: [Int: String], showsXAxis: Bool, height: CGFloat) -> some View {
        let brewCount = progress.points.count
        let domainEnd = Double(brewCount) + 0.5

        return VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption.bold())
                .foregroundStyle(.secondary)

            Chart {
                RectangleMark(
                    xStart: .value("Brew", 0.5),
                    xEnd: .value("Brew", domainEnd),
                    yStart: .value(title, 2.5),
                    yEnd: .value(title, 3.5)
                )
                .foregroundStyle(Color.accentColor.opacity(0.12))
                .accessibilityHidden(true)

                // Between the last brew of the old bag and the first of the new one.
                ForEach(progress.refillMarkers, id: \.self) { number in
                    RuleMark(x: .value("Brew", Double(number) - 0.5))
                        .foregroundStyle(Color.secondary)
                        .lineStyle(StrokeStyle(lineWidth: 1, dash: [4, 3]))
                        .accessibilityHidden(true)
                }

                if let selectedPoint {
                    RuleMark(x: .value("Brew", Double(selectedPoint.number)))
                        .foregroundStyle(.tertiary)
                        .accessibilityHidden(true)
                }

                ForEach(entries) { entry in
                    LineMark(
                        x: .value("Brew", Double(entry.point.number)),
                        y: .value(title, entry.average),
                        series: .value("Series", "Average")
                    )
                    .foregroundStyle(Color.gray.opacity(0.3))
                    .lineStyle(StrokeStyle(lineWidth: 4, lineCap: .round))
                    .interpolationMethod(.catmullRom)
                    .accessibilityHidden(true)

                    LineMark(
                        x: .value("Brew", Double(entry.point.number)),
                        y: .value(title, entry.value),
                        series: .value("Series", "Brews")
                    )
                    .foregroundStyle(Color.gray.opacity(0.6))
                    .lineStyle(StrokeStyle(lineWidth: 1))
                    .accessibilityHidden(true)

                    PointMark(
                        x: .value("Brew", Double(entry.point.number)),
                        y: .value(title, entry.value)
                    )
                    .foregroundStyle(entry.point.rating == .thumbsUp ? Color.blue : Color.red)
                    .symbolSize(60)
                    // Filled vs. hollow, so the rating doesn't rely on color alone.
                    .symbol(entry.point.rating == .thumbsUp
                            ? AnyChartSymbolShape(.circle)
                            : AnyChartSymbolShape(.circle.strokeBorder(lineWidth: 2)))
                    .accessibilityLabel(accessibilityLabel(for: entry.point))
                    .accessibilityValue(summary(of: entry.point))
                }
            }
            .chartXScale(domain: 0.5...domainEnd)
            .chartYScale(domain: 0.5...5.5)
            .chartXAxis {
                // Explicit values: a stride would start at the domain's 0.5 edge, between brews.
                // No vertical grid lines, so the dashed refill markers stand out.
                AxisMarks(preset: .aligned, values: progress.points.map { Double($0.number) }) { _ in
                    if showsXAxis {
                        AxisValueLabel(anchor: .top, collisionResolution: .greedy)
                    }
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading, values: [1, 3, 5]) { value in
                    AxisGridLine()
                    AxisValueLabel {
                        if let level = value.as(Int.self), let label = labels[level] {
                            Text(label)
                                .lineLimit(1)
                                .minimumScaleFactor(0.7)
                                .frame(width: yLabelWidth, alignment: .trailing)
                        }
                    }
                }
            }
            .chartScrollableAxes(brewCount > Self.visibleBrews ? .horizontal : [])
            .chartXVisibleDomain(length: Double(min(brewCount, Self.visibleBrews)))
            .chartScrollPosition(x: $scrollPosition)
            .chartXSelection(value: $selectedBrew)
            .frame(height: height)
        }
    }

    private var selectedPoint: DialingInProgress.Point? {
        guard let selectedBrew else { return nil }
        let number = Int(selectedBrew.rounded())
        return progress.points.first { $0.number == number }
    }

    private func accessibilityLabel(for point: DialingInProgress.Point) -> String {
        progress.refillMarkers.contains(point.number) ? "Brew \(point.number), after refill" : "Brew \(point.number)"
    }

    // "Balanced, Clean, Good"; clarity is left out when the brew has none.
    private func summary(of point: DialingInProgress.Point) -> String {
        [
            BrewTaste(rawValue: point.taste)?.description,
            point.clarity.flatMap(BrewClarity.init(rawValue:))?.description,
            point.rating.description
        ]
        .compactMap { $0 }
        .joined(separator: ", ")
    }

    // Shows the latest brews first; earlier ones are a scroll away.
    private static func latestWindowStart(brewCount: Int) -> Double {
        Double(brewCount - min(brewCount, visibleBrews)) + 0.5
    }
}


private struct LegendLabelStyle<S: ShapeStyle>: LabelStyle {
    let color: S

    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 4) {
            configuration.icon
                .foregroundStyle(color)
                .imageScale(.small)
            configuration.title
        }
    }
}


// Brews one day apart, oldest first. A refill is placed the evening before `refillBefore`.
private func previewProgress(tastes: [Int], clarities: [Int?]? = nil, refillBefore: Int? = nil) -> DialingInProgress {
    let count = tastes.count
    let brews = tastes.enumerated().map { index, taste in
        // Clean when no clarities are given; nil entries stay nil.
        let clarity: Int? = clarities.map { $0[index] } ?? 3
        let isGood = (2...4).contains(taste) && (clarity.map { (2...4).contains($0) } ?? true)
        return Brew(date: DateHelper.daysAgo(count - index - 1, hour: 8, minute: 0), beanAge: nil,
                    amountCoffee: 18, grindSetting: 10, temperature: 94, extractionTime: 30,
                    taste: taste, output: 36, rating: isGood ? .thumbsUp : .thumbsDown,
                    clarity: clarity)
    }
    let refills = refillBefore.map { number in
        [Refill(amount: 250, roastDate: .now, date: DateHelper.daysAgo(count - number + 1, hour: 20, minute: 0))]
    } ?? []
    return DialingInProgress(brews: brews, refills: refills)
}


#Preview("Converging") {
    List {
        Section("Dialing In") {
            DialingInChartView(progress: previewProgress(
                tastes: [1, 1, 2, 5, 2, 4, 2, 3, 4, 3, 3, 2, 3, 3, 4, 3, 3, 3, 3, 3],
                clarities: [1, 2, 2, 5, 2, 4, 3, 3, 4, 3, 3, 2, 3, 3, 3, 3, 3, 3, 4, 3]
            ))
        }
    }
}

#Preview("Refill") {
    List {
        Section("Dialing In") {
            DialingInChartView(progress: previewProgress(
                tastes: [2, 3, 3, 3, 3, 1, 2, 4, 3, 3],
                clarities: [2, 3, 3, 3, 3, 1, 2, 4, 3, 3],
                refillBefore: 6
            ))
        }
    }
}

#Preview("Missing Clarity") {
    List {
        Section("Dialing In") {
            DialingInChartView(progress: previewProgress(
                tastes: [1, 2, 4, 3, 3, 2, 3],
                clarities: [nil, nil, 4, 3, nil, 2, 3]
            ))
        }
    }
}

#Preview("Too Few Brews") {
    List {
        Section("Dialing In") {
            DialingInChartView(progress: previewProgress(tastes: [2, 3]))
        }
    }
}
