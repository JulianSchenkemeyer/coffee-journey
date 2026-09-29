//
//  EquipmentShelfEntryView.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 21.09.26.
//

import SwiftUI


struct EquipmentShelfEntryView: View {

    var equipment: Equipment

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(equipment.name)
                .font(.headline)

            VStack(alignment: .leading) {
                Text(equipment.brand)

                if let lastMaintenance = equipment.lastMaintenance {
                    Text("Last Maintenance: \(lastMaintenance.formatted(date: .abbreviated, time: .omitted))")
                }
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    EquipmentShelfEntryView(equipment: Equipment.Mock.leverMachine)
    EquipmentShelfEntryView(equipment: Equipment.Mock.kettle)
}
