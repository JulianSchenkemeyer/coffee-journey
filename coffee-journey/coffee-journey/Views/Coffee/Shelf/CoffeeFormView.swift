//
//  AddCoffeeFormView.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 28.10.25.
//

import Foundation
import SwiftUI

struct CoffeeFormView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.coffeeUseCases) private var coffeeUseCases
    @Environment(\.alertCoordinator) private var alertCoordinator
    
    var coffee: Coffee?

    @State private var name: String = ""
    @State private var roaster: String = ""
    @State private var initialAmount: Double = CoffeeConstants.Amount.defaultValue
    @State private var roastCategory: RoastCategory = .medium
    @State private var roastDate: Date = .now
    @State private var rating: Double = CoffeeConstants.Rating.defaultValue
    @State private var notes: String = ""
    @State private var createdCoffee: Coffee?

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name", text: $name)
                        .textInputAutocapitalization(.words)
                        .autocorrectionDisabled()

                    TextField("Roaster", text: $roaster)
                        .textInputAutocapitalization(.words)
                    
                    if isDuplicate {
                        Text("A coffee with this name and roaster already exists")
                            .foregroundStyle(.red)
                    }
                }

                Section("Roast") {
                    Picker("Roast Category", selection: $roastCategory) {
                        ForEach(RoastCategory.allCases, id: \.self) { category in
                            Text(category.rawValue.capitalized).tag(category)
                        }
                    }
                    if !isEditMode {
                        Stepper("Amount: \(initialAmount, format: .number.precision(.fractionLength(0...1))) g", value: $initialAmount,
                                in: CoffeeConstants.Amount.range,
                                step: CoffeeConstants.Amount.step)
                        
                        DatePicker("Roast Date", selection: $roastDate, displayedComponents: .date)
                    }
                }

                Section("Rating") {
                    HStack {
                        Slider(value: $rating, in: CoffeeConstants.Rating.range, step: CoffeeConstants.Rating.step) {
                            Text(String(format: "%.1f", rating))
                        }
                        
                        Text(String(format: "%.1f", rating))
                            .monospacedDigit()
                            .frame(minWidth: 44, alignment: .trailing)
                    }
                }

                Section("Notes") {
                    TextField("Tasting notes, brew methods, etc.", text: $notes, axis: .vertical)
                        .multilineTextAlignment(.leading)
                        .frame(minHeight: 120, alignment: .topLeading)
                        .lineLimit(5, reservesSpace: true)
                }
            }
            .navigationTitle(isEditMode ? "Edit Coffee" : "Add Coffee")
            .navigationDestination(item: $createdCoffee) { coffee in
                SetupRecipeView(coffee: coffee)
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(role: .close) {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(role: .confirm) { submit() }
                        .disabled(!isFormValid)
                }
            }
            .onAppear {
                loadCoffeeData()
            }
        }
        .onDismissMultiStepSheet { dismiss() }
    }
    
    private var isEditMode: Bool { coffee != nil }

    private var isNameValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private var isRoasterValid: Bool {
        !roaster.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private var isDuplicate: Bool {
        // Check if a coffee with this name and roaster already exists
        do {
            return try coffeeUseCases.checkExists(name, roaster, coffee)
        } catch {
            // If the check fails, allow the form to proceed (fail open)
            return false
        }
    }
    
    private var isFormValid: Bool {
        guard isNameValid else { return false }
        guard isRoasterValid else { return false }
        guard !isDuplicate else { return false }
        return true
    }
    
    private func loadCoffeeData() {
        guard let coffee else { return }
        
        self.name = coffee.name
        self.roaster = coffee.roaster
        self.roastCategory = .init(rawValue: coffee.roastCategory) ?? .medium
        self.roastDate = coffee.newestRefill?.roastDate ?? .now
        self.rating = coffee.rating
        self.notes = coffee.notes
    }

    private func submit() {
        guard isFormValid else { return }

        if let coffee {
            update(coffee: coffee)
        } else {
            create()
        }
    }
    
    private func update(coffee: Coffee) {
        let request = UpdateCoffeeRequest(
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            roaster: roaster.trimmingCharacters(in: .whitespacesAndNewlines),
            roastCategory: roastCategory,
            rating: rating,
            notes: notes.trimmingCharacters(in: .whitespacesAndNewlines)
        )

        do {
            _ = try coffeeUseCases.update(coffee, request)
            dismiss()
        } catch {
            alertCoordinator.show(error)
        }
    }
    
    private func create() {
        let request = CreateCoffeeRequest(
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            roaster: roaster.trimmingCharacters(in: .whitespacesAndNewlines),
            roastCategory: roastCategory,
            amount: initialAmount,
            roastDate: roastDate,
            rating: rating,
            notes: notes.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        
        do {
            createdCoffee = try coffeeUseCases.create(request)
        } catch {
            alertCoordinator.show(error)
        }
    }
}

#Preview(traits: .modifier(SampleDataModifier())) {
    CoffeeFormView()
}


