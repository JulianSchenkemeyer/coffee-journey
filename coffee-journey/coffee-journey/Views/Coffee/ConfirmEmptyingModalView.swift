//
//  ConfirmEmptyingBeansModalView.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 14.03.26.
//

import Foundation
import SwiftUI


struct ConfirmEmptyingModalView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.alertCoordinator) private var alertCoordinator
    @Environment(\.coffeeUseCases) private var coffeeUseCases
    
    let coffee: Coffee
    
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 14) {
                Text(coffee.name)
                    .font(.title2)
                    .foregroundStyle(.secondary)

                Grid(alignment: .leading, horizontalSpacing: 16, verticalSpacing: 8) {
                    GridRow {
                        Text("Beans Left:")
                        Text("\(coffee.amountLeft, format: .number.precision(.fractionLength(1))) g")
                        Image(systemName: "arrow.right")
                        Text("0.0 g")
                    }
                }
            }
            .navigationTitle("Confirm Emptying")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(role: .close) {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(role: .confirm) {
                        do {
                            _ = try coffeeUseCases.empty(coffee)
                            dismiss()
                        } catch {
                            alertCoordinator.show(error)
                        }
                    }
                }
            }
            
        }
    }
}


#Preview {
    Text("test")
        .sheet(isPresented: .constant(true)) {
            ConfirmEmptyingModalView(coffee: .Mock.espresso)
                .presentationDetents([.fraction(0.25)])
        }
}
