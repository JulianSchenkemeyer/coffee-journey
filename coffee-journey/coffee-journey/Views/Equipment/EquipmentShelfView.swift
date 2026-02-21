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
    @Environment(\.sheetCoordinator) private var sheetCoordinator
    
    @Query var equipment: [Equipment] = []
    
    var body: some View {
        RouterView {
            List(equipment) { item in
                NavigationLink(value: Router.Route.equipmentDetails(item)) {
                    VStack(alignment: .leading, spacing: 14) {
                        Text(item.name)
                            .font(.headline)
                        
                        Text(item.brand)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Equipment Shelf")
            .toolbar {
                Button("Add Equipment", systemImage: "plus") {
                    sheetCoordinator.present(.addEquipment(nil))
                }
            }
        }
    }
}


#Preview(traits: .modifier(SampleDataModifier())) {
    EquipmentShelfView()
}
