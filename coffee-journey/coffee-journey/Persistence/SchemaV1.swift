//
//  SchemaV1.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 19.03.26.
//

import Foundation
import SwiftData


/// Version 1 of the Coffee Journey schema.
///
/// All models are frozen nested types so SwiftData can compute a stable,
/// unique checksum that differs from every future schema version.
/// Never modify these types — add a new SchemaVN instead.
enum SchemaV1: VersionedSchema {
    static var versionIdentifier: Schema.Version { .init(1, 0, 0) }

    static var models: [any PersistentModel.Type] {
        [
            SchemaV1.Coffee.self,
            SchemaV1.Recipe.self,
            SchemaV1.Equipment.self,
            SchemaV1.Brew.self,
            SchemaV1.Refill.self,
        ]
    }

    @Model final class Coffee {
        var name: String
        var roaster: String
        var roastCategory: String
        var lastRefill: Date
        @Relationship(deleteRule: .cascade, inverse: \SchemaV1.Refill.coffee) var refills: [SchemaV1.Refill]
        @Relationship(deleteRule: .cascade, inverse: \SchemaV1.Brew.coffee) var brews: [SchemaV1.Brew]
        @Relationship(deleteRule: .cascade, inverse: \SchemaV1.Recipe.coffee) var recipes: [SchemaV1.Recipe]
        var amountLeft: Double
        var totalBrews: Int
        var brewsSinceRefill: Int
        var rating: Double
        var notes: String

        init(name: String, roaster: String, roastCategory: String, lastRefill: Date, amountLeft: Double, totalBrews: Int, brewsSinceRefill: Int, rating: Double, notes: String) {
            self.name = name
            self.roaster = roaster
            self.roastCategory = roastCategory
            self.lastRefill = lastRefill
            self.refills = []
            self.brews = []
            self.recipes = []
            self.amountLeft = amountLeft
            self.totalBrews = totalBrews
            self.brewsSinceRefill = brewsSinceRefill
            self.rating = rating
            self.notes = notes
        }
    }

    @Model final class Recipe {
        @Relationship(deleteRule: .nullify, inverse: \SchemaV1.Brew.recipe) var brews: [SchemaV1.Brew]
        var coffee: SchemaV1.Coffee?
        @Relationship(deleteRule: .nullify, inverse: \SchemaV1.Equipment.brewerRecipes) var brewer: SchemaV1.Equipment?
        @Relationship(deleteRule: .nullify, inverse: \SchemaV1.Equipment.grinderRecipes) var grinder: SchemaV1.Equipment?
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

        init(name: String, minTemperature: Int, maxTemperature: Int, minGrindSetting: Double, maxGrindSetting: Double, minExtractionTime: Int, maxExtractionTime: Int, minAmountBeans: Double, maxAmountBeans: Double, minOutput: Double, maxOutput: Double) {
            self.brews = []
            self.name = name
            self.minTemperature = minTemperature
            self.maxTemperature = maxTemperature
            self.minGrindSetting = minGrindSetting
            self.maxGrindSetting = maxGrindSetting
            self.minExtractionTime = minExtractionTime
            self.maxExtractionTime = maxExtractionTime
            self.minAmountBeans = minAmountBeans
            self.maxAmountBeans = maxAmountBeans
            self.minOutput = minOutput
            self.maxOutput = maxOutput
        }
    }

    @Model final class Equipment {
        var brewerRecipes: [SchemaV1.Recipe]
        var grinderRecipes: [SchemaV1.Recipe]
        var name: String
        var brand: String
        var typeDescription: String
        var notes: String

        init(name: String, brand: String, typeDescription: String, notes: String) {
            self.name = name
            self.brand = brand
            self.typeDescription = typeDescription
            self.notes = notes
            self.brewerRecipes = []
            self.grinderRecipes = []
        }
    }

    @Model final class Brew {
        var coffee: SchemaV1.Coffee?
        var recipe: SchemaV1.Recipe?
        var date: Date
        var amountCoffee: Double
        var grindSetting: Double
        var temperature: Int
        var extractionTime: Int
        var taste: Int
        var output: Double
        var ratingString: String

        init(date: Date, amountCoffee: Double, grindSetting: Double, temperature: Int, extractionTime: Int, taste: Int, output: Double, ratingString: String) {
            self.date = date
            self.amountCoffee = amountCoffee
            self.grindSetting = grindSetting
            self.temperature = temperature
            self.extractionTime = extractionTime
            self.taste = taste
            self.output = output
            self.ratingString = ratingString
        }
    }

    @Model final class Refill {
        var coffee: SchemaV1.Coffee?
        var amount: Double
        var roastDate: Date
        var date: Date

        init(amount: Double, roastDate: Date, date: Date) {
            self.amount = amount
            self.roastDate = roastDate
            self.date = date
        }
    }
}
