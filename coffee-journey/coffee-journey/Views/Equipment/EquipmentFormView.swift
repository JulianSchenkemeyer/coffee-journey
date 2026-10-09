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
    @Environment(\.alertCoordinator) private var alertCoordinator
    
    var equipment: Equipment?

    @State private var name: String = ""
    @State private var brand: String = ""
    @State private var type: EquipmentType = .machine
    @State private var isStepless = false
    @State private var startingPoint: Double = RecipeConstants.GrindSetting.defaultValue
    @State private var notes: String = ""


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
                    
                    if type == .grinder {
                        Toggle(isOn: $isStepless) {
                            Text("Is stepless?")
                        }
                        
                        Stepper("Starting Point: \(startingPoint, format: .number.precision(.fractionLength(isStepless ? 1 : 0)))",
                                value: $startingPoint,
                                in: RecipeConstants.GrindSetting.range,
                                step: isStepless ? RecipeConstants.GrindSetting.steplessStep : RecipeConstants.GrindSetting.steppedStep)
                    }
                }

                Section("Notes") {
                    TextField("Tasting notes, brew methods, etc.", text: $notes, axis: .vertical)
                        .multilineTextAlignment(.leading)
                        .frame(minHeight: 120, alignment: .topLeading)
                        .lineLimit(5, reservesSpace: true)
                }
            }
            .navigationTitle(equipment == nil ? "Add Equipment" : "Edit Equipment")
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
                loadEquipmentData()
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

    private func loadEquipmentData() {
        guard let equipment else { return }

        name = equipment.name
        brand = equipment.brand
        type = equipment.type
        notes = equipment.notes
        if let options = equipment.grinderOptions {
            isStepless = options.isStepless
            startingPoint = options.startingPoint
        }
    }

    private func submit() {
        guard isFormValid else { return }

        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedBrand = brand.trimmingCharacters(in: .whitespacesAndNewlines)
        // Only grinders carry options; retyping a grinder clears them.
        let grinderOptions = type == .grinder
            ? GrinderOptions(isStepless: isStepless, startingPoint: startingPoint)
            : nil
        
        do {
            if let equipment {
                let request = UpdateEquipmentRequest(
                    name: trimmedName,
                    brand: trimmedBrand,
                    type: type,
                    notes: notes,
                    grinderOptions: grinderOptions
                )
                _ = try equipmentUseCases.update(equipment, request)
            } else {
                let request = CreateEquipmentRequest(
                    name: trimmedName,
                    brand: trimmedBrand,
                    type: type,
                    notes: notes,
                    grinderOptions: grinderOptions
                )
                _ = try equipmentUseCases.create(request)
            }
            dismiss()
        } catch {
            alertCoordinator.show(error)
        }
    }
}

#Preview(traits: .modifier(SampleDataModifier())) {
    EquipmentFormView()
}


