//
//  Recipe+PreviewMocks.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 02.02.26.
//

#if DEBUG
extension Recipe {
    struct Mock {
        static let espresso = Recipe(name: "Default", temperature: 94.0, grindsize: 10, extractionTime: 33, input: 18.4, output: 37.3)
        static let espressoUsed = Recipe(name: "Default", minTemperature: 92.0, maxTemperature: 96.0, minGrindSize: 9, maxGrindSize: 11, minExtractionTime: 30, maxExtractionTime: 36, minBeans: 18.2, maxBeans: 18.6, minOutput: 37.0, maxOutput: 37.6)

        static let turbo = Recipe(name: "Turbo", temperature: 94.0, grindsize: 14, extractionTime: 20, input: 18.3, output: 36.5)
        static let turboUsed = Recipe(name: "Turbo", minTemperature: 93.0, maxTemperature: 95.0, minGrindSize: 13, maxGrindSize: 15, minExtractionTime: 18, maxExtractionTime: 22, minBeans: 18.0, maxBeans: 18.6, minOutput: 36.8, maxOutput: 37.4)
                                       
        static let allNew = [espresso, turbo]
        static let allUsed = [espressoUsed, turboUsed]
        
        static let all: [Recipe] = allNew + allUsed
    }
}
#endif
