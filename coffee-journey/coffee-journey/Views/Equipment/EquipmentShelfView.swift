//
//  EquipmentShelfView.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 17.11.25.
//

//
//  CoffeeShelfView.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 01.11.25.
//

import Foundation
import SwiftUI
import SwiftData


struct EquipmentShelfView: View {
    @Environment(\.router) private var router
    
    @Query var equipment: [Equipment] = []
    
    var body: some View {
        @Bindable var router = router
        
        NavigationStack(path: $router.path) {
            List(equipment) { item in
                NavigationLink(value: Router.Route.equipmentDetails(item)) {
                    Text(item.name)
                }
            }
            .navigationTitle("Equipment Shelf")
            .toolbar {
                Button("Add Equipment", systemImage: "plus") {
                    // TODO: Add sheet coordinator for add equipment
                }
            }
            .navigationDestination(for: Router.Route.self) { route in
                switch route {
                case .coffeeDetails(let coffee):
                    CoffeeDetailsView(coffee: coffee)
                case .equipmentDetails(let equipment):
                    Text("Equipment Details: \(equipment.name)")
                case .brewHistory(let coffee):
                    BrewHistoryView(coffee: coffee)
                }
            }
        }
    }
}


#Preview {
    PreviewUseCaseEnvironment {
        EquipmentShelfView()
    }
}
