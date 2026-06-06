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
            let groupedEquipment = Dictionary(grouping: equipment, by: \.type)
            
            List(EquipmentType.allCases, id: \.self) { type in
                if let items = groupedEquipment[type] {
                    Section(type.description.capitalized) {
                        ForEach(items) { item in
                            NavigationLink(value: Router.Route.equipmentDetails(item)) {
                                VStack(alignment: .leading, spacing: 14) {
                                    Text(item.name)
                                        .font(.headline)
                                    
                                    VStack(alignment: .leading) {
                                        Text(item.brand)

                                        if let lastMaintenance = item.lastMaintenance {
                                            Text("Last Maintenance: \(lastMaintenance.formatted(date: .abbreviated, time: .omitted))")
                                        }
                                    }
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Equipment Shelf")
            .toolbar {
                Button("Add Equipment", systemImage: CJSymbol.Action.add) {
                    sheetCoordinator.present(.addEquipment(nil))
                }
            }
        }
    }
}


#Preview(traits: .modifier(SampleDataModifier())) {
    EquipmentShelfView()
}
