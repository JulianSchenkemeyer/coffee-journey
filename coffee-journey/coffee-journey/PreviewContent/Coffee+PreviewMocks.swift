import Foundation

// MARK: - Coffee Preview Mocks
// These mocks are intended for SwiftUI previews and tests.
#if DEBUG
extension Coffee {
    struct Mock {
        static let espresso = Coffee(
            name: "Ethiopia Yirgacheffe",
            roaster: "Blue Bottle",
            roastCategory: "Light",
            amount: 250,
            amountLeft: 250,
            lastRefill: Calendar.current.date(byAdding: .day, value: -3, to: .now) ?? .now,
            brews: [],
            totalBrews: 5,
            brewsSinceRefill: 1,
            roastDate: Calendar.current.date(byAdding: .day, value: -17, to: .now) ?? .now,
            rating: 4.5,
            notes: "Floral, citrus, tea-like body"
        )
        
        static let filter = Coffee(
            name: "Colombia Huila",
            roaster: "Square Mile",
            roastCategory: "Medium",
            amount: 250,
            amountLeft: 0, //75.5,
            lastRefill: Calendar.current.date(byAdding: .day, value: -3, to: .now) ?? .now,
            brews: [],
            totalBrews: 15,
            brewsSinceRefill: 3,
            roastDate: Calendar.current.date(byAdding: .day, value: -14, to: .now) ?? .now,
            rating: 4.0,
            notes: "Caramel, red apple, balanced"
        )
        
        static let darkRoast = Coffee(
            name: "Sumatra Mandheling",
            roaster: "Local Roasters",
            roastCategory: "Dark",
            amount: 250,
            amountLeft: 0,
            lastRefill: Calendar.current.date(byAdding: .day, value: -3, to: .now) ?? .now,
            brews: [],
            totalBrews: 54,
            brewsSinceRefill: 0,
            roastDate: Calendar.current.date(byAdding: .day, value: -3, to: .now) ?? .now,
            rating: 3.5,
            notes: "Chocolate, spice, low acidity"
        )
        
        static let coffees = [espresso, filter, darkRoast]
    }
}
#endif
