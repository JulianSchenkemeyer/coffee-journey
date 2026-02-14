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
        content()
            .modelContainer(container)
            .environment(\.useCases, UseCaseFactory.make(context: ModelContext(container)))
            .environment(\.sheetCoordinator, SheetCoordinator())
            .environment(\.router, Router())
    }
}
#endif
