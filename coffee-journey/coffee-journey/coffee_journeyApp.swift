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
    
    init() {
        self.context = ModelContext(container)
    }
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .environment(\.modelContext, context)
        .environment(\.useCases, UseCaseFactory.make(context: context))
        .environment(\.sheetCoordinator, sheetManager)
    }
}
