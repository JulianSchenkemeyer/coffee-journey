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

    enum ModalSheet: Identifiable {
        case brew(Coffee)
        case refill(Coffee)
        
        var id: String {
            switch self {
            case .brew: "brew"
            case .refill: "refill"
            }
        }
    }
    
    
    @State private var showAddCoffee: Bool = false
    @State private var activeModal: ModalSheet? = nil
    @State private var selectedCoffee: Coffee? = nil
    
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
        NavigationStack {
            List(selection: $selectedCoffee) {
                ForEach(inStockCoffees) { coffee in
                    NavigationLink(value: coffee) {
                        CoffeeShelfEntryView(coffee: coffee)
                            .swipeActions(edge: .leading) {
                                Button {
                                    activeModal = .brew(coffee)
                                } label: {
                                    Label("Brew", systemImage: "cup.and.heat.waves.fill")
                                }                    }
                            .swipeActions(edge: .trailing) {
                                Button {
                                    activeModal = .refill(coffee)
                                } label: {
                                    Label("Refill", systemImage: "arrow.trianglehead.clockwise")
                                }
                            }
                    }
                }
        
                Section("Previous") {
                    ForEach(emptyCoffees) { coffee in
                        NavigationLink(value: coffee) {
                            CoffeeShelfEntryView(coffee: coffee)
                                .swipeActions(edge: .leading) {
                                    Button {
                                        activeModal = .brew(coffee)
                                    } label: {
                                        Label("Brew", systemImage: "cup.and.heat.waves.fill")
                                    }                    }
                                .swipeActions(edge: .trailing) {
                                    Button {
                                        activeModal = .refill(coffee)
                                    } label: {
                                        Label("Refill", systemImage: "arrow.trianglehead.clockwise")
                                    }
                                }
                        }
                        .listRowBackground(Color.secondary.opacity(0.15))
                    }
                }
            }
            .navigationTitle("Coffee Shelf")
            .toolbar {
                Button("Add Coffee", systemImage: "plus") {
                    showAddCoffee = true
                }
            }
            .navigationDestination(item: $selectedCoffee, destination: { coffee in
                CoffeeDetailsView(coffee:  coffee)
            })
            .sheet(item: $activeModal, content: { modal in
                switch modal {
                case .brew(let coffee):
                    BrewDrinkModalView(coffee: coffee)
                        .presentationDetents([.fraction(0.9)])
                case .refill(let coffee):
                    RefillBeansModalView(coffee: coffee)
                        .presentationDetents([.medium])
                }
            })
            .sheet(isPresented: $showAddCoffee) {
                AddCoffeeFormView()
            }
        }
    }
}


#Preview {
    PreviewUseCaseEnvironment {
        CoffeeShelfView()
    }
}

