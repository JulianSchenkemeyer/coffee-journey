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
        case brew
        case refill
        
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
                CoffeeShelfEntryView(coffee: coffee)
                    .swipeActions(edge: .leading) {
                        Button {
                            selectedCoffee = coffee
                            activeModal = .brew
                        } label: {
                            Label("Brew", systemImage: "cup.and.heat.waves.fill")
                        }                    }
                    .swipeActions(edge: .trailing) {
                        Button {
                            selectedCoffee = coffee
                            activeModal = .refill
                        } label: {
                            Label("Refill", systemImage: "arrow.trianglehead.clockwise")
                        }
                    }
            }
            .navigationTitle("Coffee Shelf")
            .toolbar {
                Button("Add Coffee", systemImage: "plus") {
                    showAddCoffee = true
                }
            }
            .sheet(item: $activeModal, content: { modal in
                switch modal {
                case .brew:
                    BrewDrinkModalView(coffee: selectedCoffee!)
                        .presentationDetents([.medium])
                case .refill:
                    RefillBeansModalView(coffee: selectedCoffee!)
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

