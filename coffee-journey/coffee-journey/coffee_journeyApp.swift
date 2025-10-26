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
    let container: ModelContainer = {
        let schema = Schema([Coffee.self])
        return try! ModelContainer(for: schema)
    }()
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .environment(\.modelContext, ModelContext(container))
        .environment(\.useCases, makeUseCases(container: container))
    }
    
    @MainActor
    func makeUseCases(container: ModelContainer) -> UseCases {
        let context = ModelContext(container)
        let coffeeRepository = SwiftDataCoffeeRepository(context: context)
        
        let createCoffee = CreateCoffee(repository: coffeeRepository).callAsFunction
        
        return UseCases(createCoffee: createCoffee)
    }
}
