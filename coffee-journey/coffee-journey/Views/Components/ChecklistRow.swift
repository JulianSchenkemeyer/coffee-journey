//
//  ChecklistRow.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 26.04.26.
//

import SwiftUI


struct ChecklistRow: View {
    let title: String
    var notes: String? = nil
    let isDone: Bool
    let onToggle: () -> Void

    var body: some View {
        Button(action: onToggle) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: isDone ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(isDone ? Color.accentColor : .secondary)
                    .font(.title3)

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .strikethrough(isDone)
                        .foregroundStyle(isDone ? .secondary : .primary)

                    if let notes, !notes.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        Text(notes)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .buttonStyle(.plain)
    }
}


#Preview {
    @Previewable @State var firstDone = false
    @Previewable @State var secondDone = true

    Form {
        ChecklistRow(title: "Backflush with water", isDone: firstDone) {
            firstDone.toggle()
        }
        ChecklistRow(
            title: "Backflush with cleaner",
            notes: "Use Cafiza",
            isDone: secondDone
        ) {
            secondDone.toggle()
        }
    }
}
