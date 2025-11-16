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
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .environment(\.modelContext, ModelContext(container))
        .environment(\.useCases, UseCaseFactory.make(container: container))
    }
}
