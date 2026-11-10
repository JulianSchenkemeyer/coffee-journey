//
//  RestCurve.swift
//  coffee-journey
//

// Good and bad brews per week off roast: days 0–7, 8–14, 15–21, …
struct RestCurve {
    struct Bucket: Identifiable {
        let index: Int
        var good = 0
        var bad = 0

        var id: Int { index }
        var firstDay: Int { index == 0 ? 0 : index * 7 + 1 }
        var lastDay: Int { index * 7 + 7 }
        var total: Int { good + bad }
    }

    // Consecutive from the first week through the latest one, empty weeks included.
    let buckets: [Bucket]
    // Brews with a known bean age; the others are left out rather than counted as day 0.
    let brewCount: Int

    static func bucketIndex(forDay day: Int) -> Int {
        Swift.max(day - 1, 0) / 7
    }

    init(brews: [Brew]) {
        let aged = brews.compactMap { brew in brew.beanAge.map { (day: $0, rating: brew.rating) } }
        brewCount = aged.count

        guard !aged.isEmpty else {
            buckets = []
            return
        }

        let indices = aged.map { Self.bucketIndex(forDay: $0.day) }
        var buckets = (0...(indices.max() ?? 0)).map { Bucket(index: $0) }

        for (brew, index) in zip(aged, indices) {
            switch brew.rating {
            case .thumbsUp: buckets[index].good += 1
            case .thumbsDown: buckets[index].bad += 1
            }
        }
        self.buckets = buckets
    }
}
