//
//  AddCoffeeModalView.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 28.10.25.
//

import Foundation
import SwiftUI

struct AddCoffeeModalView: View {
    private enum Stage {
        case details
        case recipe

        var contentTransition: AnyTransition {
            switch self {
            case .details:
                .move(edge: .leading)
            case .recipe:
                .move(edge: .trailing)
            }
        }
    }

    @Environment(\.sheetCoordinator) private var sheetCoordinator
    @Environment(\.coffeeUseCases) private var coffeeUseCases
    @Environment(\.alertCoordinator) private var alertCoordinator

    var coffee: Coffee?

    @State private var stage: Stage = .details

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
            VStack {
                switch stage {
                case .details:
                    CoffeeFormView(
                        name: $name,
                        roaster: $roaster,
                        initialAmount: $initialAmount,
                        roastCategory: $roastCategory,
                        roastDate: $roastDate,
                        rating: $rating,
                        notes: $notes,
                        isEditMode: isEditMode,
                        isDuplicate: isDuplicate
                    )
                    .navigationTitle(isEditMode ? "Edit Coffee" : "Add Coffee")
                    .transition(stage.contentTransition)

                case .recipe:
                    if let createdCoffee {
                        SetupRecipeView(coffee: createdCoffee)
                            .transition(stage.contentTransition)
                    }
                }
            }
            .toolbar {
                if stage == .details {
                    ToolbarItem(placement: .cancellationAction) {
                        Button(role: .close) {
                            sheetCoordinator.dismiss()
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button(role: .confirm) { submit() }
                            .disabled(!isFormValid)
                    }
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
            sheetCoordinator.dismiss()
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
            withAnimation { stage = .recipe }
        } catch {
            alertCoordinator.show(error)
        }
    }
}

#Preview(traits: .modifier(SampleDataModifier())) {
    AddCoffeeModalView()
}


