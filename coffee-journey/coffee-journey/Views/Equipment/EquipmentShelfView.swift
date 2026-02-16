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
        RouterView {
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
        }
    }
}


#Preview {
    PreviewUseCaseEnvironment {
        EquipmentShelfView()
    }
}
