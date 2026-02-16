//
//  RefillBeansModalView.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 23.11.25.
//

import SwiftUI


struct RefillBeansModalView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.coffeeUseCases) private var coffeeUseCases
    
    let coffee: Coffee
    
    @State private var newBeans = 250.0
    @State private var roastDate = Date.now
    @State private var keepOld: Bool = true
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section {
                        Stepper("Coffee: \(newBeans, format: .number.precision(.fractionLength(0...1))) g",
                                value: $newBeans,
                                in: 0...2000,
                                step: 5)
                        DatePicker("Roast Date", selection: $roastDate, displayedComponents: .date)
                        
                        Toggle(isOn: $keepOld) {
                            Text("Keep Old Beans")
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                Button {
                    _ = try! coffeeUseCases.refill(coffee, Refill(amount: newBeans, roastDate: roastDate, date: .now), !keepOld)
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
