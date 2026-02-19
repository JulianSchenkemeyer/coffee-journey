//
//  EquipmentDetailsView.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 19.02.26.
//
import Foundation
import SwiftUI


struct EquipmentDetailsView: View {
    let equipment: Equipment
    
    var body: some View {
        Text(equipment.name)
    }
}


#Preview {
    EquipmentDetailsView(equipment: .Mock.leverMachine)
}
