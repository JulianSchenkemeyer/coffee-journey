//
//  coffee_journeyApp.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 24.10.25.
//

import SwiftUI
import SwiftData

@main
struct coffee_journeyApp: App {
    let container: ModelContainer = ContainerFactory.createDefault()
    let context: ModelContext
    let sheetManager = SheetCoordinator()
    let router = Router()
    
    let coffeeUseCases: CoffeeUseCases
    let recipeUseCases: RecipeUseCases
    let equipmentUseCases: EquipmentUseCases
    
    init() {
        self.context = ModelContext(container)
        
        // Create all use cases once during initialization
        let useCases = UseCaseFactory.makeAll(context: context)
        self.coffeeUseCases = useCases.coffee
        self.recipeUseCases = useCases.recipe
        self.equipmentUseCases = useCases.equipment
    }
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .environment(\.modelContext, context)
        .environment(\.coffeeUseCases, coffeeUseCases)
        .environment(\.recipeUseCases, recipeUseCases)
        .environment(\.equipmentUseCases, equipmentUseCases)
        .environment(\.sheetCoordinator, sheetManager)
        .environment(\.router, router)
    }
}
