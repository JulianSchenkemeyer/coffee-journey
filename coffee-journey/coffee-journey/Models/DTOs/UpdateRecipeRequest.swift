//
//  UpdateRecipeRequest.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 05.03.26.
//

struct UpdateRecipeRequest {
    let name: String
    let brewer: Equipment?
    let grinder: Equipment?
    let temperature: Int
    let grindSetting: Double
    let extractionTime: Int
    let amountBeans: Double
    let output: Double
}
