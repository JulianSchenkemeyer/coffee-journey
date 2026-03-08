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
    @Environment(\.alertCoordinator) private var alertCoordinator
    
    let coffee: Coffee
    
    @State private var newBeans = CoffeeConstants.Amount.defaultValue
    @State private var roastDate = Date.now
    @State private var keepOld: Bool = true
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section {
                        Stepper("Coffee: \(newBeans, format: .number.precision(.fractionLength(0...1))) g",
                                value: $newBeans,
                                in: CoffeeConstants.Amount.range,
                                step: CoffeeConstants.Amount.step)
                        DatePicker("Roast Date", selection: $roastDate, displayedComponents: .date)
                        
                        Toggle(isOn: $keepOld) {
                            Text("Keep Old Beans")
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                Button {
                    refillBeans()
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
    
    private func refillBeans() {
        do {
            _ = try coffeeUseCases.refill(coffee, Refill(amount: newBeans, roastDate: roastDate, date: .now), !keepOld)
            dismiss()
        } catch {
            alertCoordinator.show(error)
        }
    }
}


#Preview {
    RefillBeansModalView(coffee: Coffee.Mock.espresso)
}
