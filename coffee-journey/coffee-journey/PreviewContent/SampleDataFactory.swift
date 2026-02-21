//
//  SampleDataFactory.swift
//  coffee-journey
//
//  Created by Claude on 20.02.26.
//

import Foundation
import SwiftData

#if DEBUG

/// Factory for creating fresh sample data instances for previews
enum SampleDataFactory {
    
    // MARK: - Coffee
    
    static func createCoffees() -> [Coffee] {
        let espresso = Coffee(
            name: "Ethiopia Yirgacheffe",
            roaster: "Blue Bottle",
            roastCategory: "Light",
            amount: 250,
            amountLeft: 250,
            lastRefill: Calendar.current.date(byAdding: .day, value: -3, to: .now) ?? .now,
            brews: [],
            recipes: [
                Recipe(name: "Default", temperature: 94.0, grindsize: 10, extractionTime: 33, input: 18.4, output: 37.3),
                Recipe(name: "Turbo", temperature: 94.0, grindsize: 14, extractionTime: 20, input: 18.3, output: 36.5)
            ],
            totalBrews: 5,
            brewsSinceRefill: 1,
            roastDate: Calendar.current.date(byAdding: .day, value: -17, to: .now) ?? .now,
            rating: 4.5,
            notes: "Floral, citrus, tea-like body"
        )
        
        let filter = Coffee(
            name: "Colombia Huila",
            roaster: "Square Mile",
            roastCategory: "Medium",
            amount: 250,
            amountLeft: 0,
            lastRefill: Calendar.current.date(byAdding: .day, value: -3, to: .now) ?? .now,
            brews: [],
            recipes: [],
            totalBrews: 15,
            brewsSinceRefill: 3,
            roastDate: Calendar.current.date(byAdding: .day, value: -14, to: .now) ?? .now,
            rating: 4.0,
            notes: "Caramel, red apple, balanced"
        )
        
        let darkRoast = Coffee(
            name: "Sumatra Mandheling",
            roaster: "Local Roasters",
            roastCategory: "Dark",
            amount: 250,
            amountLeft: 0,
            lastRefill: Calendar.current.date(byAdding: .day, value: -3, to: .now) ?? .now,
            brews: [],
            recipes: [],
            totalBrews: 54,
            brewsSinceRefill: 0,
            roastDate: Calendar.current.date(byAdding: .day, value: -3, to: .now) ?? .now,
            rating: 3.5,
            notes: "Chocolate, spice, low acidity"
        )
        
        return [espresso, filter, darkRoast]
    }
    
    // MARK: - Equipment
    
    static func createEquipment() -> [Equipment] {
        let leverMachine = Equipment(
            name: "Lever Machine",
            brand: "Generic",
            type: EquipmentType.machine.rawValue,
            notes: ""
        )
        
        let kettle = Equipment(
            name: "Electric Kettle",
            brand: "Generic",
            type: EquipmentType.kettle.rawValue,
            notes: ""
        )
        
        return [leverMachine, kettle]
    }
    
    // MARK: - Brews
    
    static func createBrews(for coffee: Coffee) -> [Brew] {
        var brews: [Brew] = []
        let recipes = coffee.recipes
        
        for index in 0..<10 {
            let daysAgo = -index / 2
            let hour = index % 2 == 0 ? 9 : 14
            
            let brew = Brew(
                date: DateHelper.daysAgo(daysAgo, hour: hour, minute: 30),
                amountCoffee: index % 2 == 0 ? 18.0 : 20.0,
                grindSetting: index % 2 == 0 ? 5.0 : 20.0,
                waterTemperature: index % 2 == 0 ? 93.0 : 96.0,
                extractionTime: index % 2 == 0 ? 30 : 180,
                taste: (index % 5) + 1,
                output: index % 2 == 0 ? 36.0 : 320.0,
                rating: index % 3 == 0 ? .thumbsDown : .thumbsUp
            )
            
            // Link to coffee
            brew.coffee = coffee
            
            // Alternate between recipes if available
            if !recipes.isEmpty {
                brew.recipe = recipes[index % recipes.count]
            }
            
            brews.append(brew)
        }
        
        return brews
    }
    
    // MARK: - Complete Sample Data
    
    /// Seeds a ModelContext with complete sample data including relationships
    static func seedContext(_ context: ModelContext) throws {
        // Create and insert coffees
        let coffees = createCoffees()
        for coffee in coffees {
            context.insert(coffee)
        }
        
        // Create and insert equipment
        let equipment = createEquipment()
        for item in equipment {
            context.insert(item)
        }
        
        // Create and insert brews (linked to first coffee)
        if let firstCoffee = coffees.first {
            let brews = createBrews(for: firstCoffee)
            for brew in brews {
                context.insert(brew)
            }
        }
        
        try context.save()
    }
}

#endif
