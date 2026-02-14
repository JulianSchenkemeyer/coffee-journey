//
//  BrewsOverviewView.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 10.02.26.
//
import Foundation
import SwiftUI


struct BrewHistoryView: View {
    let coffeeName: String
    let brews: [Brew]
    
    var body: some View {
        List(brews) { brew in
            VStack(alignment: .leading, spacing: 8) {
                // Date and Rating
                HStack {
                    Text(brew.date, format: .dateTime)
                        .font(.headline)
                    Spacer()
                    Text(brew.rating == .thumbsUp ? "👍" : "👎")
                        .font(.title3)
                }
                
                // Taste with visual indicator
                VStack(alignment: .leading, spacing: 4) {

                    
                    // Taste scale bar
                    HStack(spacing: 4) {
                        ForEach(1...5, id: \.self) { value in
                            RoundedRectangle(cornerRadius: 2)
                                .fill(value == brew.taste ? Color.accentColor : Color.gray.opacity(0.3))
                                .frame(height: 6)
                        }
                    }
                    
                    HStack {
                        Text("Taste:")
                            .fontWeight(.medium)
                        Text(brew.tasteDescription.description)
                            .foregroundStyle(.secondary)
                    }
                    
                    Divider()
                }
                
                // Brew parameters
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 0) {
                        // Left column
                        HStack(spacing: 6) {
                            Image(systemName: "scalemass.fill")
                                .foregroundStyle(.primary)
                                .frame(width: 20)
                            Text("Coffee:")
                                .fontWeight(.medium)
                            Text("\(brew.amountCoffee.formatted())g")
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // Right column
                        HStack(spacing: 6) {
                            Image(systemName: "dial.high.fill")
                                .foregroundStyle(.primary)
                                .frame(width: 20)
                            Text("Grind:")
                                .fontWeight(.medium)
                            Text("\(brew.grindSetting.formatted())")
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    HStack(spacing: 0) {
                        // Left column
                        HStack(spacing: 6) {
                            Image(systemName: "thermometer.medium")
                                .foregroundStyle(.primary)
                                .frame(width: 20)
                            Text("Temp:")
                                .fontWeight(.medium)
                            Text("\(brew.waterTemperature.formatted())°C")
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // Right column
                        HStack(spacing: 6) {
                            Image(systemName: "timer")
                                .foregroundStyle(.primary)
                                .frame(width: 20)
                            Text("Time:")
                                .fontWeight(.medium)
                            Text("\(brew.extractionTime)s")
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    HStack(spacing: 6) {
                        Image(systemName: "drop.fill")
                            .foregroundStyle(.primary)
                            .frame(width: 20)
                        Text("Output:")
                            .fontWeight(.medium)
                        Text("\(brew.output.formatted())ml")
                            .foregroundStyle(.secondary)
                    }
                }
                .font(.subheadline)
            }
            .padding(.vertical, 4)
        }
        .navigationTitle(coffeeName)
    }
}


#Preview {
    PreviewUseCaseEnvironment {
        NavigationStack {
            BrewHistoryView(coffeeName: Coffee.Mock.espresso.name, brews: Brew.Mock.brews)
        }
    }
}
