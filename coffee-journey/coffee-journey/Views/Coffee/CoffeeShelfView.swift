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
    
    @Environment(\.useCases) private var useCases: UseCases
    
    @State private var showAddCoffee: Bool = false
    @State private var activeModal: ModalSheet? = nil
    @State private var selectedCoffee: Coffee? = nil
    
    @Query(sort: [
        SortDescriptor(\Coffee.roastDate, order: .reverse),
        SortDescriptor(\Coffee.amountLeft, order: .reverse)
    ]) var coffees: [Coffee] = []
    
    
    var body: some View {
        NavigationStack {
            List(coffees, selection: $selectedCoffee) { coffee in
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
            .navigationTitle("Coffee Shelf")
            .toolbar {
                Button("Add Coffee", systemImage: "plus") {
                    showAddCoffee = true
                }
            }
            .navigationDestination(item: $selectedCoffee, destination: { coffee in
                CoffeeDetails(coffee:  coffee)
            })
            .sheet(item: $activeModal, content: { modal in
                switch modal {
                case .brew(let coffee):
                    BrewDrinkModalView(coffee: coffee)
                        .presentationDetents([.medium])
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

