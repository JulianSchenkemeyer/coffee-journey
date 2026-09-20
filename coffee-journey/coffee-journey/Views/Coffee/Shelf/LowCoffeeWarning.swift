//
//  LowCoffeeWarning.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 06.06.26.
//

import Foundation
import SwiftUI


struct LowCoffeeWarning: View {
    var body: some View {
        VStack {
            Text("☕️ Low Amount of Coffee")
                .font(.title3.bold())
            Text("You should refill your coffee supply soon")
        }
        .padding()
        .glassEffect(.regular.tint(.yellow.opacity(0.15)), in: .rect(cornerRadius: 24))
    }
    
}


#Preview {
    LowCoffeeWarning()
}
