//
//  EquipmentHeaderView.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 19.02.26.
//

import Foundation
import SwiftUI


struct EquipmentHeaderView: View {
    let equipment: Equipment

    var body: some View {
        VStack {
            Grid(alignment: .leading, horizontalSpacing: 0, verticalSpacing: 12) {
                GridRow {
                    Label("Type", systemImage: CJSymbol.Equipment.type)
                        .foregroundStyle(.secondary)

                    Spacer()
                        .gridCellUnsizedAxes(.vertical)

                    Text(equipment.type.description.capitalized)
                        .gridColumnAlignment(.trailing)
                }

                GridRow {
                    Label("Brand", systemImage: CJSymbol.Equipment.brand)
                        .foregroundStyle(.secondary)

                    Spacer()
                        .gridCellUnsizedAxes(.vertical)

                    Text(equipment.brand.isEmpty ? "—" : equipment.brand)
                        .gridColumnAlignment(.trailing)
                }
            }
            .font(.callout)
            .frame(maxWidth: .infinity)
        }
    }
}


#Preview {
    EquipmentHeaderView(equipment: .Mock.leverMachine)
        .padding()
}
