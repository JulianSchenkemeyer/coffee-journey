//
//  CoffeeShelfEntryView.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 17.11.25.
//

import SwiftUI


struct CoffeeShelfEntryView: View {
    
    var coffee: Coffee
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(coffee.name)
                .font(.title3)
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(coffee.roaster)
                    Text(
                        coffee.roastDate,
                        format: .dateTime
                            .hour(.omitted)
                            .minute(.omitted)
                    )
                }
                
                Spacer()
                
                VStack(spacing: 4) {
                    Text(Measurement(value: coffee.amountLeft, unit: UnitMass.grams), format: .measurement(width: .abbreviated, usage: .asProvided))
                        .foregroundStyle(.primary)
                    
                    
                }
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    CoffeeShelfEntryView(coffee: Coffee.Mock.espresso)
    CoffeeShelfEntryView(coffee: Coffee.Mock.filter)
    CoffeeShelfEntryView(coffee: Coffee.Mock.darkRoast)
}
