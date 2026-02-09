//
//  ContentView.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 24.10.25.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.useCases) private var useCases
    @Environment(\.sheetCoordinator) private var sheetCoordinator
        
    var body: some View {
        @Bindable var sheetCoordinator = sheetCoordinator
        
        TabView {
            Tab("Coffee", systemImage: "cup.and.heat.waves") {
                CoffeeShelfView()
            }
            Tab("Equipment", systemImage: "wrench.and.screwdriver") {
                EquipmentShelfView()
            }
            
            Tab(role: .search) {
                SearchView()
            }
        }
        .sheet(item: $sheetCoordinator.activeSheet) { sheet in
            switch sheet {
            case .brew(let coffee):
                BrewDrinkModalView(coffee: coffee)
                    .presentationDetents([.fraction(0.9)])
            case .refill(let coffee):
                RefillBeansModalView(coffee: coffee)
                    .presentationDetents([.medium])
            case .addCoffee:
                AddCoffeeFormView()
            case .editRecipe(let recipe):
                Text("Edit Recipe: \(recipe.name)")
            }
        }
    }
}

#Preview {
    PreviewUseCaseEnvironment {
        ContentView()
    }
}
