import Foundation

// MARK: - Coffee Preview Mocks
// These mocks are intended for SwiftUI previews and tests.
extension Coffee {
    struct Mock {
        // Canonical, deterministic examples
        static let espresso = Coffee(
            name: "Ethiopia Yirgacheffe",
            roaster: "Blue Bottle",
            roastCategory: "Light",
            roastDate: Calendar.current.date(byAdding: .day, value: -7, to: .now) ?? .now,
            rating: 4.5,
            notes: "Floral, citrus, tea-like body"
        )
        
        static let filter = Coffee(
            name: "Colombia Huila",
            roaster: "Square Mile",
            roastCategory: "Medium",
            roastDate: Calendar.current.date(byAdding: .day, value: -14, to: .now) ?? .now,
            rating: 4.0,
            notes: "Caramel, red apple, balanced"
        )
        
        static let darkRoast = Coffee(
            name: "Sumatra Mandheling",
            roaster: "Local Roasters",
            roastCategory: "Dark",
            roastDate: Calendar.current.date(byAdding: .day, value: -3, to: .now) ?? .now,
            rating: 3.5,
            notes: "Chocolate, spice, low acidity"
        )
    }
}
