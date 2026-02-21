//
//  PreviewUsecaseEnvironment.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 20.11.25.
//
import SwiftUI
import SwiftData

#if DEBUG

// MARK: - Modern PreviewModifier Approach

/// PreviewModifier that provides a seeded SwiftData container and all required environment dependencies.
/// 
/// Usage:
/// ```swift
/// #Preview(traits: .modifier(SampleDataModifier())) {
///     @Previewable @Query var coffees: [Coffee]
///     return CoffeeShelfView()
/// }
/// ```
struct SampleDataModifier: PreviewModifier {
    
    static func makeSharedContext() throws -> ModelContainer {
        let container = ContainerFactory.createInMemory()
        let context = container.mainContext
        
        // Seed context with sample data
        try SampleDataFactory.seedContext(context)
        
        return container
    }
    
    func body(content: Content, context: ModelContainer) -> some View {
        let modelContext = ModelContext(context)
        let useCases = UseCaseFactory.makeAll(context: modelContext)
        
        content
            .modelContainer(context)
            .environment(\.coffeeUseCases, useCases.coffee)
            .environment(\.recipeUseCases, useCases.recipe)
            .environment(\.equipmentUseCases, useCases.equipment)
            .environment(\.brewUseCases, useCases.brew)
            .environment(\.sheetCoordinator, SheetCoordinator())
            .environment(\.router, Router())
    }
}

// MARK: - Legacy Preview Environment (Deprecated)

/// **DEPRECATED:** Use `SampleDataModifier` with `#Preview(traits: .modifier(SampleDataModifier()))` instead.
/// 
/// This wrapper is kept for backward compatibility but will be removed in a future update.
@available(*, deprecated, message: "Use #Preview(traits: .modifier(SampleDataModifier())) instead")
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
            .environment(\.brewUseCases, useCases.brew)
            .environment(\.sheetCoordinator, SheetCoordinator())
            .environment(\.router, Router())
    }
}

#endif
