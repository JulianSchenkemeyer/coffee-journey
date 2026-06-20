//
//  CoffeeFormView.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 28.10.25.
//

import SwiftUI


struct CoffeeFormView: View {
    @Binding var name: String
    @Binding var roaster: String
    @Binding var initialAmount: Double
    @Binding var roastCategory: RoastCategory
    @Binding var roastDate: Date
    @Binding var rating: Double
    @Binding var notes: String

    let isEditMode: Bool
    let isDuplicate: Bool

    var body: some View {
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
    }
}


#Preview {
    @Previewable @State var name = "Ethiopia Yirgacheffe"
    @Previewable @State var roaster = "Local Roaster"
    @Previewable @State var initialAmount = CoffeeConstants.Amount.defaultValue
    @Previewable @State var roastCategory: RoastCategory = .medium
    @Previewable @State var roastDate: Date = .now
    @Previewable @State var rating = CoffeeConstants.Rating.defaultValue
    @Previewable @State var notes = ""

    NavigationStack {
        CoffeeFormView(
            name: $name,
            roaster: $roaster,
            initialAmount: $initialAmount,
            roastCategory: $roastCategory,
            roastDate: $roastDate,
            rating: $rating,
            notes: $notes,
            isEditMode: false,
            isDuplicate: false
        )
    }
}
