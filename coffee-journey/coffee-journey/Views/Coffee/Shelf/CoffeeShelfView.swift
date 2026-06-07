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
        sort: [SortDescriptor(\Coffee.lastRefill, order: .forward),
               SortDescriptor(\Coffee.amountLeft, order: .reverse)]
    ) private var inStockCoffees: [Coffee]

    @Query(
        filter: #Predicate<Coffee> {
            $0.amountLeft == 0 && $0.lastRefill >= oneYearAgo
        },
        sort: [SortDescriptor(\Coffee.lastRefill, order: .reverse)]
    ) private var emptyCoffees: [Coffee]
    
    
    var isLowOnCoffee: Bool {
        inStockCoffees.reduce(0) { $0 + $1.amountLeft } < CoffeeConstants.Amount.lowThreshold
    }

    var body: some View {
        RouterView {
            List {
                ForEach(inStockCoffees) { coffee in
                    NavigationLink(value: Router.Route.coffeeDetails(coffee)) {
                        CoffeeShelfEntryView(coffee: coffee)
                    }
                    .swipeActions(edge: .leading) {
                        Button("Brew", systemImage: CJSymbol.Action.brew) {
                            sheetCoordinator.present(.brew(coffee))
                        }
                    }
                    .swipeActions(edge: .trailing) {
                        Button("Refill", systemImage: CJSymbol.Action.refill) {
                            sheetCoordinator.present(.refill(coffee))
                        }

                        Button("Empty", systemImage: CJSymbol.Action.clear) {
                            sheetCoordinator.present(.confirmEmptying(coffee))
                        }
                    }
                }

                Section("Previous") {
                    ForEach(emptyCoffees) { coffee in
                        NavigationLink(value: Router.Route.coffeeDetails(coffee)) {
                            CoffeeShelfEntryView(coffee: coffee)
                        }
                        .swipeActions(edge: .trailing) {
                            Button("Refill", systemImage: CJSymbol.Action.refill) {
                                sheetCoordinator.present(.refill(coffee))
                            }
                        }
                        .listRowBackground(Color.secondary.opacity(0.15))
                    }
                }
            }
            .navigationTitle("Coffee Shelf")
            .safeAreaInset(edge: .bottom) {
                if isLowOnCoffee {
                    LowCoffeeWarning()
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                        .background(.clear)
                }
            }
            .toolbar {
                Button("Add Coffee", systemImage: CJSymbol.Action.add) {
                    sheetCoordinator.present(.addCoffee(nil))
                }
            }
        }
    }
}


#Preview(traits: .modifier(SampleDataModifier())) {
    CoffeeShelfView()
}

