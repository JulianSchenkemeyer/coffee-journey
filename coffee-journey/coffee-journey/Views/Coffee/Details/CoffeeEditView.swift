//
//  CoffeeEditView.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 21.06.26.
//

import SwiftUI


/// Pushed editing screen for an existing coffee. Reuses the presentational
/// `CoffeeFormView`; amount and roast date are not editable here.
struct CoffeeEditView: View {
    @Environment(\.router) private var router
    @Environment(\.coffeeUseCases) private var coffeeUseCases
    @Environment(\.alertCoordinator) private var alertCoordinator

    let coffee: Coffee

    @State private var name: String = ""
    @State private var roaster: String = ""
    @State private var roastCategory: RoastCategory = .medium
    @State private var rating: Double = CoffeeConstants.Rating.defaultValue
    @State private var notes: String = ""

    var body: some View {
        CoffeeFormView(
            name: $name,
            roaster: $roaster,
            initialAmount: .constant(CoffeeConstants.Amount.defaultValue),
            roastCategory: $roastCategory,
            roastDate: .constant(.now),
            rating: $rating,
            notes: $notes,
            isEditMode: true,
            isDuplicate: isDuplicate
        )
        .navigationTitle("Edit Coffee")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button(role: .confirm) { submit() }
                    .disabled(!isFormValid)
            }
        }
        .onAppear {
            loadCoffeeData()
        }
    }

    private var isNameValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private var isRoasterValid: Bool {
        !roaster.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private var isDuplicate: Bool {
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
        self.name = coffee.name
        self.roaster = coffee.roaster
        self.roastCategory = .init(rawValue: coffee.roastCategory) ?? .medium
        self.rating = coffee.rating
        self.notes = coffee.notes
    }

    private func submit() {
        guard isFormValid else { return }

        let request = UpdateCoffeeRequest(
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            roaster: roaster.trimmingCharacters(in: .whitespacesAndNewlines),
            roastCategory: roastCategory,
            rating: rating,
            notes: notes.trimmingCharacters(in: .whitespacesAndNewlines)
        )

        do {
            _ = try coffeeUseCases.update(coffee, request)
            router.navigateBack()
        } catch {
            alertCoordinator.show(error)
        }
    }
}
