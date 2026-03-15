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
                    
                    if let latestRefill = coffee.newestRefill {
                        Text(
                            latestRefill.roastDate,
                            format: .dateTime
                                .hour(.omitted)
                                .minute(.omitted)
                        )
                        
                        Text(latestRefill.roastDate,
                             format: Date.RelativeFormatStyle(
                                allowedFields: [.day, .week], presentation: .numeric)
                        )
                        .foregroundStyle(coffee.amountLeft == 0 ? .secondary : roast​Freshness​Color(for: latestRefill.roastDate))
                    }

                }
                
                Spacer()
                
                VStack(spacing: 4) {
                    Text(Measurement(value: coffee.amountLeft, unit: UnitMass.grams),
                         format: .measurement(width: .abbreviated, usage: .asProvided)
                    )
                        .foregroundStyle(.primary)
                    
                    Text("Brews: \(coffee.totalBrews)")
                }
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
    }
    
    private func roast​Freshness​Color(for date: Date) -> Color {
        let days = Calendar.current.dateComponents([.day], from: date, to: .now).day ?? 0
        switch days {
        case ..<8:   return .yellow.opacity(0.5)
        case ..<35:  return .secondary
        case ..<45: return .red.opacity(0.4) // getting older
        case ..<60: return .red.opacity(0.5)
        case ..<68: return .red.opacity(0.75)
        case ..<75: return .red
        default: return .secondary
        }
    }
}

#Preview {
    CoffeeShelfEntryView(coffee: Coffee.Mock.espresso)
    CoffeeShelfEntryView(coffee: Coffee.Mock.filter)
    CoffeeShelfEntryView(coffee: Coffee.Mock.darkRoast)
}
