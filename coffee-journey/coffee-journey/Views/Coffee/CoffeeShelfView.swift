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
    @Environment(\.useCases) private var useCases: UseCases
    
    @State private var showAddCoffee: Bool = false
    @State private var showBrewModal: Bool = false
    
    @Query(sort: [
        SortDescriptor(\Coffee.roastDate, order: .reverse),
        SortDescriptor(\Coffee.amountLeft, order: .reverse)
    ]) var coffees: [Coffee] = []
    
    
    var body: some View {
        NavigationStack {
            List(coffees) { coffee in
                CoffeeShelfEntryView(coffee: coffee)
                    .swipeActions(edge: .leading) {
                        Button {
                            showBrewModal = true
                        } label: {
                            Label("Brew", systemImage: "cup.and.heat.waves.fill")
                        }
                    }
                    .swipeActions(edge: .trailing) {
                        Button {
                            _ = try! useCases.refillBeans(coffee, true)
                        } label: {
                            Label("Refill", systemImage: "arrow.trianglehead.clockwise")
                        }
                    }
                    .sheet(isPresented: $showBrewModal) {
                        BrewDrinkModalView(coffee: coffee)
                            .presentationDetents([.medium])
                    }
            }
            .navigationTitle("Coffee Shelf")
            .toolbar {
                Button("Add Coffee", systemImage: "plus") {
                    showAddCoffee = true
                }
            }
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

