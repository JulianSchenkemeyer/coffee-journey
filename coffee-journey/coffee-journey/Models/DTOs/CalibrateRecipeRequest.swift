//
//  CalibrateRecipeRequest.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 15.02.26.
//

struct CalibrateRecipeRequest {
    let recipe: Recipe
    
    let temperature: Int
    let grindSetting: Double
    let extractionTime: Int
    let amountBeans: Double
    let output: Double
}
