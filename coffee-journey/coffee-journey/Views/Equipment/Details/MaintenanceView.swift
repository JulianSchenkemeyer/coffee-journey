//
//  MaintenanceView.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 19.04.26.
//

import Foundation
import SwiftData
import SwiftUI


struct MaintenanceView: View {
    @Environment(\.dismiss) private var dismiss

    var maintenanceTemplate: MaintenanceTemplate?

    @State private var completedStepIDs: Set<PersistentIdentifier> = []
    @State private var isEditingTemplate = false

    var orderedSteps: [MaintenanceTemplateStep] {
        guard let maintenanceTemplate else { return [] }
        return maintenanceTemplate.steps.sorted(by: { $0.sortOrder < $1.sortOrder })
    }

    var body: some View {
        NavigationStack {
            Form {
                ForEach(orderedSteps) { step in
                    ChecklistRow(
                        title: step.title,
                        notes: step.notes,
                        isDone: completedStepIDs.contains(step.id)
                    ) {
                        if completedStepIDs.contains(step.id) {
                            completedStepIDs.remove(step.id)
                        } else {
                            completedStepIDs.insert(step.id)
                        }
                    }
                }
            }
            .navigationTitle("Maintenance Template")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Edit", systemImage: "pencil") {
                        guard maintenanceTemplate != nil else { return }
                        isEditingTemplate = true
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                Button {
                    submit()
                } label: {
                    Text("Complete Maintenance")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .disabled(maintenanceTemplate == nil)
                .padding()
            }
            .navigationDestination(isPresented: $isEditingTemplate) {
                if let template = maintenanceTemplate {
                    MaintenanceTemplateForm(template: template)
                }
            }
        }
    }
    
    private func submit() {
        
    }
}


#Preview {
    MaintenanceView(maintenanceTemplate: MaintenanceTemplate(
        title: "Espresso Machine",
        equipment: nil,
        steps: [
            MaintenanceTemplateStep(title: "Backflush with water", notes: "", sortOrder: 0),
            MaintenanceTemplateStep(title: "Backflush with cleaner", notes: "Use Cafiza", sortOrder: 1),
            MaintenanceTemplateStep(title: "Rinse group head", notes: "", sortOrder: 2),
        ]
    ))
}
