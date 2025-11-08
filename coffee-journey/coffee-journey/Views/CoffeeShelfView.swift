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
    @State private var showAddCoffee: Bool = false
    
    @Query var coffees: [Coffee] = []
    
    var body: some View {
        NavigationStack {
            List(coffees) { coffee in
                Text(coffee.name)
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
    CoffeeShelfView()
}
