//
//  RefillBeansModalView.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 23.11.25.
//

import SwiftUI


struct RefillBeansModalView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.useCases) private var useCases: UseCases
    
    let coffee: Coffee
    
    @State private var newBeans = 250.0
    @State private var roastDate = Date.now
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section {
                        Stepper("Coffee: \(newBeans, format: .number.precision(.fractionLength(0...1))) g",
                                value: $newBeans,
                                in: 0...2000,
                                step: 50)
                        DatePicker("Roast Date", selection: $roastDate, displayedComponents: .date)
                    }
                    .padding(.vertical, 8)
                }
                
                Button {
                    _ = try! useCases.refillBeans(coffee, Refill(amount: newBeans, roastDate: roastDate, date: .now), true)
                    dismiss()
                } label: {
                    Label("Refill Beans", systemImage: "arrow.trianglehead.clockwise")
                        .fontWeight(.semibold)
                        .padding()
                }
            }
            .buttonStyle(.glassProminent)
            .frame(maxWidth: .infinity)
            .navigationTitle(coffee.name)
            .navigationSubtitle("Refill your Supply")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(role: .cancel) {
                        dismiss()
                    }
                }
            }
        }
    }
}


#Preview {
    RefillBeansModalView(coffee: Coffee.Mock.espresso)
}
