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
    
    var coffee: Coffee?

    @State private var name: String = ""
    @State private var roaster: String = ""
    @State private var initialAmount: Double = 250
    @State private var roastCategory: RoastCategory = .medium
    @State private var roastDate: Date = .now
    @State private var rating: Double = 3.0
    @State private var notes: String = ""
    @State private var submitErrorMessage: String? = nil

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
                                in: 0...2000,
                                step: 5)
                        
                        DatePicker("Roast Date", selection: $roastDate, displayedComponents: .date)
                    }
                }

                Section("Rating") {
                    HStack {
                        Slider(value: $rating, in: 0...5, step: 0.5) {
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
                
                if let submitErrorMessage {
                    Section {
                        Text(submitErrorMessage)
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle(isEditMode ? "Edit Coffee" : "Add Coffee")
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
        submitErrorMessage = nil
        guard isFormValid else { return }

        if let coffee {
            update(coffee: coffee)
        } else {
            create()
        }
    }
    
    private func update(coffee: Coffee) {
        coffee.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        coffee.roaster = roaster.trimmingCharacters(in: .whitespacesAndNewlines)
        coffee.roastCategory = roastCategory.rawValue
        coffee.rating = rating
        coffee.notes = notes.trimmingCharacters(in: .whitespacesAndNewlines)
        
        do {
            _ = try coffeeUseCases.update(coffee)
            dismiss()
        } catch {
            submitErrorMessage = error.localizedDescription
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
            _ = try coffeeUseCases.create(request)
            dismiss()
        } catch {
            submitErrorMessage = error.localizedDescription
        }
    }
}

#Preview {
    PreviewUseCaseEnvironment {
        CoffeeFormView()
    }
}


