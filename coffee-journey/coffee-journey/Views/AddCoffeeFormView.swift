//
//  AddCoffeeFormView.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 28.10.25.
//

import Foundation
import SwiftUI

struct AddCoffeeFormView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.useCases) private var useCases

    @State private var name: String = ""
    @State private var roaster: String = ""
    @State private var roastCategory: RoastCategory = .medium
    @State private var roastDate: Date = .now
    @State private var rating: Double = 3.0
    @State private var notes: String = ""

    @State private var submitErrorMessage: String? = nil


    var body: some View {
        NavigationStack {
            Form {
                Section("Details") {
                    TextField("Name", text: $name)
                        .textInputAutocapitalization(.words)
                        .autocorrectionDisabled()

                    TextField("Roaster", text: $roaster)
                        .textInputAutocapitalization(.words)
                }

                Section("Roast") {
                    Picker("Roast Category", selection: $roastCategory) {
                        ForEach(RoastCategory.allCases, id: \.self) { category in
                            Text(category.rawValue.capitalized).tag(category)
                        }
                    }
                    DatePicker("Roast Date", selection: $roastDate, displayedComponents: .date)
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
            .navigationTitle("Add Coffee")
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
        }
    }

    private var isNameValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private var isFormValid: Bool {
        guard isNameValid else { return false }
        return true
    }

    private func submit() {
        submitErrorMessage = nil
        guard isFormValid else { return }

        let request = CreateCoffeeRequest(
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            roaster: roaster.trimmingCharacters(in: .whitespacesAndNewlines),
            roastCategory: roastCategory,
            roastDate: roastDate,
            rating: rating,
            notes: notes.trimmingCharacters(in: .whitespacesAndNewlines)
        )

        do {
            _ = try useCases.createCoffee(request)
            dismiss()
        } catch {
            submitErrorMessage = error.localizedDescription
        }
    }
}

#Preview {
    AddCoffeeFormView()
        .environment(\.useCases, UseCases(createCoffee: { req in
            Coffee(
                name: req.name,
                roaster: req.roaster,
                roastCategory: req.roastCategory.rawValue,
                roastDate: req.roastDate,
                rating: req.rating,
                notes: req.notes
            )
        }, createEquipement: { _ in fatalError("Not implemented")}))
}


