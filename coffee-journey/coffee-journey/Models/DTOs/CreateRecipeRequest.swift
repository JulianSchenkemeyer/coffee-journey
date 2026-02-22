//
//  CreateRecipeRequest.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 01.02.26.
//

struct CreateRecipeRequest {
    let grinder: Equipment
    let brewer: Equipment
    
    let coffee: Coffee
    let name: String
    let temperature: Double
    let grindSize: Double
    let extractionTime: Int
    let amountBeans: Double
    let output: Double
}
