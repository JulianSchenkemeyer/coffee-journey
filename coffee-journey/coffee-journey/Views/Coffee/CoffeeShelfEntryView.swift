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
        VStack(alignment: .leading, spacing: 5) {
            Text(coffee.name)
                .font(.title3)
            
            HStack {
                Text(coffee.roaster)
                Spacer()
                Text(
                    coffee.roastDate,
                    format: .dateTime
                        .hour(.omitted)
                        .minute(.omitted)
                )
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    CoffeeShelfEntryView(coffee: Coffee.Mock.espresso)
}
