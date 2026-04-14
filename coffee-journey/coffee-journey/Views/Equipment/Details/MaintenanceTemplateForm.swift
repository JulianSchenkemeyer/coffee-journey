//
//  MaintenanceTemplateForm.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 31.03.26.
//

import Foundation
import SwiftUI
import SwiftData


struct MaintenanceTemplateForm: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.equipmentUseCases) private var equipmentUseCases
    @Environment(\.alertCoordinator) private var alertCoordinator

    let template: MaintenanceTemplate
    
    @State private var steps: [StepItem] = []
    @FocusState private var focusedStepID: UUID?
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(steps) { step in
                        stepRow(for: step)
                    }
                    
                    Button {
                        addStep()
                    } label: {
                        Label("New Step", systemImage: "plus.circle.fill")
                            .foregroundStyle(.green)
                    }
                }
            }
            .navigationTitle("Maintenance Template")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(role: .confirm) { submit() }
                }
            }
            .onAppear {
                steps = template.steps
                    .sorted { $0.sortOrder < $1.sortOrder }
                    .map { StepItem(title: $0.title, notes: $0.notes) }
            }
        }
    }
    
    @ViewBuilder
    private func stepRow(for step: StepItem) -> some View {
        if let index = steps.firstIndex(where: { $0.id == step.id }) {
            MaintenanceStepRow(step: $steps[index], isFocused: focusedStepID == step.id)
                .focused($focusedStepID, equals: step.id)
                .draggable(step.id.uuidString) {
                    Text(step.title.isEmpty ? "New Step" : step.title)
                        .padding(8)
                        .background(.regularMaterial, in: .rect(cornerRadius: 8))
                }
                .dropDestination(for: String.self) { droppedItems, _ in
                    return handleDrop(droppedItems, onto: step)
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        deleteStep(at: index)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
        }
    }

    private func handleDrop(_ droppedItems: [String], onto targetStep: StepItem) -> Bool {
        guard let draggedIDString = droppedItems.first,
              let draggedID = UUID(uuidString: draggedIDString),
              let fromIndex = steps.firstIndex(where: { $0.id == draggedID }),
              let toIndex = steps.firstIndex(where: { $0.id == targetStep.id }),
              fromIndex != toIndex else { return false }

        withAnimation {
            let item: StepItem = steps.remove(at: fromIndex)
            steps.insert(item, at: toIndex)
        }
        return true
    }

    private func deleteStep(at index: Int) {
        _ = withAnimation {
            steps.remove(at: index)
        }
    }

    private func addStep() {
        let newStep = StepItem(title: "", notes: "")
        steps.append(newStep)
        focusedStepID = newStep.id
    }

    private func submit() {
        let stepData = steps.enumerated().compactMap { index, step -> MaintenanceStepData? in
            let title = step.title.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !title.isEmpty else { return nil }
            return MaintenanceStepData(
                title: title,
                notes: step.notes.trimmingCharacters(in: .whitespacesAndNewlines),
                sortOrder: index
            )
        }

        let request = UpdateMaintenanceTemplateRequest(steps: stepData)

        do {
            _ = try equipmentUseCases.updateMaintenanceTemplate(template, request)
            dismiss()
        } catch {
            alertCoordinator.show(error)
        }
    }
}

// MARK: - Step Row

private struct MaintenanceStepRow: View {
    @Binding var step: StepItem
    var isFocused: Bool
    
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            TextField("Step title", text: $step.title)
                .fontWeight(.medium)
            
            if isExpanded || !step.notes.isEmpty {
                TextField("Notes", text: $step.notes, axis: .vertical)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1...5)
            }
        }
        .onChange(of: isFocused) { _, focused in
            withAnimation {
                isExpanded = focused
            }
        }
    }
}

// MARK: - Local Step Model

struct StepItem: Identifiable {
    let id = UUID()
    var title: String
    var notes: String
}


#Preview(traits: .modifier(SampleDataModifier())) {
    MaintenanceTemplateForm(template: MaintenanceTemplate(title: "Espresso Machine", equipment: nil, steps: []))
}

#Preview("With existing steps", traits: .modifier(SampleDataModifier())) {
    MaintenanceTemplateForm(template: MaintenanceTemplate(
        title: "Espresso Machine",
        equipment: nil,
        steps: [
            MaintenanceTemplateStep(title: "Backflush with water", notes: "", sortOrder: 0),
            MaintenanceTemplateStep(title: "Backflush with cleaner", notes: "Use Cafiza", sortOrder: 1),
            MaintenanceTemplateStep(title: "Rinse group head", notes: "", sortOrder: 2),
        ]
    ))
}
