//
//  SchemaV2.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 19.03.26.
//

import Foundation
import SwiftData


/// Version 2 of the Coffee Journey schema.
///
/// Changes from V1:
/// - `Equipment` gains `maintenanceCounter: Int` (default 0, lightweight migration).
/// - New schemas for `MaintenanceTemplate`, `MaintenanceTemplateStep` and `MaintenanceInstance`
enum SchemaV2: VersionedSchema {
    static var versionIdentifier: Schema.Version { .init(2, 0, 0) }

    static var models: [any PersistentModel.Type] {
        [
            SchemaV2.Coffee.self,
            SchemaV2.Recipe.self,
            SchemaV2.Equipment.self,
            SchemaV2.Brew.self,
            SchemaV2.Refill.self,
            SchemaV2.MaintenanceTemplate.self,
            SchemaV2.MaintenanceTemplateStep.self,
            SchemaV2.MaintenanceInstance.self,
        ]
    }
    
    @Model final class Brew {
        var coffee: Coffee?
        var recipe: Recipe?
        
        var date: Date
        var amountCoffee: Double
        var grindSetting: Double
        var temperature: Int
        var extractionTime: Int
        var taste: Int
        
        var output: Double
        var ratingString: String

        
        init(date: Date, amountCoffee: Double, grindSetting: Double, temperature: Int, extractionTime: Int, taste: Int, output: Double, rating: BrewRating) {
            self.date = date
            self.amountCoffee = amountCoffee
            self.grindSetting = grindSetting
            self.temperature = temperature
            self.extractionTime = extractionTime
            self.taste = taste
            self.output = output
            self.ratingString = rating.rawValue
        }
    }
    
    @Model final class Coffee {
        var name: String
        var roaster: String
        var roastCategory: String
        
        var lastRefill: Date
        @Relationship(deleteRule: .cascade, inverse: \Refill.coffee) var refills: [Refill]
        @Relationship(deleteRule: .cascade, inverse: \Brew.coffee) var brews: [Brew]
        @Relationship(deleteRule: .cascade, inverse: \Recipe.coffee) var recipes: [Recipe]
        var amountLeft: Double
        
        var totalBrews: Int
        var brewsSinceRefill: Int
        
        var rating: Double
        var notes: String
        
        
        init(
            name: String,
            roaster: String,
            roastCategory: String,
            amount: Double,
            amountLeft: Double,
            lastRefill: Date,
            brews: [Brew],
            recipes: [Recipe],
            totalBrews: Int,
            brewsSinceRefill: Int,
            roastDate: Date,
            rating: Double,
            notes: String
        ) {
            self.name = name
            self.roaster = roaster
            self.roastCategory = roastCategory
            self.lastRefill = lastRefill
            self.amountLeft = amountLeft
            self.refills = [.init(amount: amount, roastDate: roastDate, date: .now)]
            self.brews = brews
            self.recipes = recipes
            self.totalBrews = totalBrews
            self.brewsSinceRefill = brewsSinceRefill
            self.rating = rating
            self.notes = notes
        }
    }
    
    @Model final class Equipment {
        var brewerRecipes: [Recipe]
        var grinderRecipes: [Recipe]
        
        var name: String
        var brand: String
        var typeDescription: String

        @Relationship(deleteRule: .cascade, inverse: \MaintenanceTemplate.equipment) var maintenanceTemplate: MaintenanceTemplate?
        
        var notes: String
        var maintenanceCounter: Int?
        var lastMaintenance: Date?
        var totalUses: Int?
        var usesSinceLastMaintenance: Int?
        
        init(name: String, brand: String, type: String, notes: String) {
            self.name = name
            self.brand = brand
            self.typeDescription = type
            self.notes = notes
            self.maintenanceCounter = 0
            self.totalUses = 0
            self.usesSinceLastMaintenance = 0
            self.brewerRecipes = []
            self.grinderRecipes = []
        }
    }
    
    @Model final class Recipe {
        @Relationship(deleteRule: .nullify, inverse: \Brew.recipe) var brews: [Brew] = []
        var coffee: Coffee?
        
        @Relationship(deleteRule: .nullify, inverse: \Equipment.brewerRecipes) var brewer: Equipment?
        @Relationship(deleteRule: .nullify, inverse: \Equipment.grinderRecipes) var grinder: Equipment?
        
        var name: String
        var lastUsed: Date?
        
        var minTemperature: Int
        var maxTemperature: Int
        
        var minGrindSetting: Double
        var maxGrindSetting: Double
        
        var minExtractionTime: Int
        var maxExtractionTime: Int
        
        var minAmountBeans: Double
        var maxAmountBeans: Double
        
        var minOutput: Double
        var maxOutput: Double
        
        init(
            name: String,
            minTemperature: Int,
            maxTemperature: Int,
            minGrindSetting: Double,
            maxGrindSetting: Double,
            minExtractionTime: Int,
            maxExtractionTime: Int,
            minBeans: Double,
            maxBeans: Double,
            minOutput: Double,
            maxOutput: Double,
            brewer: Equipment? = nil,
            grinder: Equipment? = nil
        ) {
            self.brewer = brewer
            self.grinder = grinder
            self.name = name
            self.minTemperature = minTemperature
            self.maxTemperature = maxTemperature
            self.minGrindSetting = minGrindSetting
            self.maxGrindSetting = maxGrindSetting
            self.minExtractionTime = minExtractionTime
            self.maxExtractionTime = maxExtractionTime
            self.minAmountBeans = minBeans
            self.maxAmountBeans = maxBeans
            self.minOutput = minOutput
            self.maxOutput = maxOutput
        }
    }
    
    @Model final class Refill {
        var coffee: Coffee?
        var amount: Double
        var roastDate: Date
        var date: Date
        
        
        init(amount: Double, roastDate: Date, date: Date) {
            self.amount = amount
            self.roastDate = roastDate
            self.date = date
        }
    }
    
    @Model final class MaintenanceTemplate {
        var title: String
        var equipment: Equipment?
        
        @Relationship(deleteRule: .cascade, inverse: \MaintenanceTemplateStep.template) var steps: [MaintenanceTemplateStep]
        @Relationship(deleteRule: .nullify, inverse: \MaintenanceInstance.template) var instances: [MaintenanceInstance]
        
        init(title: String, equipment: Equipment?, steps: [MaintenanceTemplateStep]) {
            self.title = title
            self.equipment = equipment
            self.steps = steps
            self.instances = []
        }
    }
    
    @Model final class MaintenanceTemplateStep {
        var title: String
        var notes: String
        var sortOrder: Int
        
        var template: MaintenanceTemplate?
        
        init(title: String, notes: String, sortOrder: Int) {
            self.title = title
            self.notes = notes
            self.sortOrder = sortOrder
        }
    }
    
    @Model final class MaintenanceInstance {
        var template: MaintenanceTemplate?
        var completedAt: Date
        
        var completedSteps: [String]
        var uncompletedSteps: [String]
        
        
        init(template: MaintenanceTemplate, completedAt: Date, completedSteps: [String], uncompletedSteps: [String]) {
            self.template = template
            self.completedAt = completedAt
            self.completedSteps = completedSteps
            self.uncompletedSteps = uncompletedSteps
        }
        
        init(template: MaintenanceTemplate, completedAt: Date) {
            self.template = template
            self.completedAt = completedAt
            self.completedSteps = []
            self.uncompletedSteps = []
        }
    }
}
