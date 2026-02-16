//
//  PreviewUsecaseEnvironment.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 20.11.25.
//
import SwiftUI
import SwiftData

#if DEBUG
struct PreviewUseCaseEnvironment<Content: View>: View  {
    let container = PreviewContainer.seeded(with: Coffee.Mock.coffees + Equipment.Mock.all + Brew.Mock.brews)
    
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        let context = ModelContext(container)
        let useCases = UseCaseFactory.makeAll(context: context)
        
        content()
            .modelContainer(container)
            .environment(\.coffeeUseCases, useCases.coffee)
            .environment(\.recipeUseCases, useCases.recipe)
            .environment(\.equipmentUseCases, useCases.equipment)
            .environment(\.sheetCoordinator, SheetCoordinator())
            .environment(\.router, Router())
    }
}
#endif
