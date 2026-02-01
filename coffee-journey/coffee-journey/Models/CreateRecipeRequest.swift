//
//  CreateRecipeRequest.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 01.02.26.
//

struct CreateRecipeRequest {
    let brewer: Equipment
    let grinder: Equipment
    
    let name: String
    let grindSize: Double
    let temperature: Double
    let extractionTime: Int
    let amountBeans: Double
    let output: Double
}
