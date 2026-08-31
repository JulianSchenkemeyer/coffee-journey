//
//  BrewSummary.swift
//  coffee-journey
//

// The brew parameters and their derived metrics, for a recorded Brew or for one
// still being composed in the brew form.
struct BrewSummary {
    let amountCoffee: Double
    let grindSetting: Double
    let temperature: Int
    let extractionTime: Int
    let output: Double

    var ratio: Double? {
        guard amountCoffee > 0 else { return nil }
        return output / amountCoffee
    }

    var flowRate: Double? {
        guard extractionTime > 0 else { return nil }
        return output / Double(extractionTime)
    }
}


extension BrewSummary {
    init(brew: Brew) {
        self.init(
            amountCoffee: brew.amountCoffee,
            grindSetting: brew.grindSetting,
            temperature: brew.temperature,
            extractionTime: brew.extractionTime,
            output: brew.output
        )
    }
}
