//
//  AddEquipmentFormView.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 31.10.25.
//


import Foundation
import SwiftUI

struct EquipmentFormView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.equipmentUseCases) private var equipmentUseCases
    
    var equipment: Equipment?

    @State private var name: String = ""
    @State private var brand: String = ""
    @State private var type: EquipmentType = .machine
    @State private var notes: String = ""

    @State private var submitErrorMessage: String? = nil


    var body: some View {
        NavigationStack {
            Form {
                Section("Details") {
                    TextField("Name", text: $name)
                        .textInputAutocapitalization(.words)
                        .autocorrectionDisabled()

                    TextField("Brand", text: $brand)
                        .textInputAutocapitalization(.words)
                    
                    Picker("Type", selection: $type) {
                        ForEach(EquipmentType.allCases, id: \.self) { category in
                            Text(category.rawValue.capitalized).tag(category)
                        }
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
            .navigationTitle("Add Equipment")
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

        let request = CreateEquipmentRequest(
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            brand: brand.trimmingCharacters(in: .whitespacesAndNewlines),
            type: type,
            notes: notes
        )
        
        do {
            _ = try equipmentUseCases.create(request)
            dismiss()
        } catch {
            submitErrorMessage = error.localizedDescription
        }
    }
}

#Preview {
    PreviewUseCaseEnvironment {
        EquipmentFormView()
    }
}


