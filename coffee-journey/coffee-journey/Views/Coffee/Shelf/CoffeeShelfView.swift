//
//  CoffeeShelfView.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 01.11.25.
//

import Foundation
import SwiftUI
import SwiftData


struct CoffeeShelfView: View {
    static var oneYearAgo = Date.oneYearAgo
    
    @Environment(\.sheetCoordinator) private var sheetCoordinator
    @Environment(\.router) private var router
    
    @Query(
        filter: #Predicate<Coffee> { $0.amountLeft > 0 },
        sort: [SortDescriptor(\Coffee.amountLeft, order: .reverse),
               SortDescriptor(\Coffee.lastRefill, order: .reverse)]
    ) private var inStockCoffees: [Coffee]

    @Query(
        filter: #Predicate<Coffee> {
            $0.amountLeft == 0 && $0.lastRefill >= oneYearAgo
        },
        sort: [SortDescriptor(\Coffee.lastRefill, order: .reverse)]
    ) private var emptyCoffees: [Coffee]
    
    
    var body: some View {
        @Bindable var router = router
        
        NavigationStack(path: $router.path) {
            List {
                ForEach(inStockCoffees) { coffee in
                    NavigationLink(value: Router.Route.coffeeDetails(coffee)) {
                        CoffeeShelfEntryView(coffee: coffee)
                    }
                    .swipeActions(edge: .leading) {
                        Button {
                            sheetCoordinator.present(.brew(coffee))
                        } label: {
                            Label("Brew", systemImage: "cup.and.heat.waves.fill")
                        }
                    }
                    .swipeActions(edge: .trailing) {
                        Button {
                            sheetCoordinator.present(.refill(coffee))
                        } label: {
                            Label("Refill", systemImage: "arrow.trianglehead.clockwise")
                        }
                    }
                }
        
                Section("Previous") {
                    ForEach(emptyCoffees) { coffee in
                        NavigationLink(value: Router.Route.coffeeDetails(coffee)) {
                            CoffeeShelfEntryView(coffee: coffee)
                        }
                        .swipeActions(edge: .trailing) {
                            Button {
                                sheetCoordinator.present(.refill(coffee))
                            } label: {
                                Label("Refill", systemImage: "arrow.trianglehead.clockwise")
                            }
                        }
                        .listRowBackground(Color.secondary.opacity(0.15))
                    }
                }
            }
            .navigationTitle("Coffee Shelf")
            .toolbar {
                Button("Add Coffee", systemImage: "plus") {
                    sheetCoordinator.present(.addCoffee)
                }
            }
            .navigationDestination(for: Router.Route.self) { route in
                switch route {
                case .coffeeDetails(let coffee):
                    CoffeeDetailsView(coffee: coffee)
                case .brewHistory(let coffeeName, let brews):
                    BrewHistoryView(coffeeName: coffeeName, brews: brews)
                case .equipmentDetails(let equipment):
                    Text("Equipment Details: \(equipment.name)")
                }
            }
        }
    }
}


#Preview {
    PreviewUseCaseEnvironment {
        CoffeeShelfView()
    }
}

