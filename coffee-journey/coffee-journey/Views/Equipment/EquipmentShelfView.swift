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
    @State private var showAddEquipment: Bool = false
    
    @Query var equipment: [Equipment] = []
    
    var body: some View {
        NavigationStack {
            List(equipment) { item in
                Text(item.name)
            }
            .navigationTitle("Equipment Shelf")
            .toolbar {
                Button("Add Equipment", systemImage: "plus") {
                    showAddEquipment = true
                }
            }
            .sheet(isPresented: $showAddEquipment) {
                AddEquipmentFormView()
            }
        }
    }
}


#Preview {
    PreviewUseCaseEnvironment {
        EquipmentShelfView()
    }
}
