//
//  EquipmentDetailsView.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 19.02.26.
//
import Foundation
import SwiftUI
import SwiftData


struct EquipmentDetailsView: View {
    @Environment(\.sheetCoordinator) private var sheetCoordinator
    @Environment(\.alertCoordinator) private var alertCoordinator
    @Environment(\.router) private var router
    @Environment(\.equipmentUseCases) private var equipmentUseCases

    let equipment: Equipment
    
    @State private var showDeleteConfirmation = false

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 24) {
                EquipmentHeaderView(equipment: equipment)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 24)

                if !equipment.notes.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Notes")
                            .font(.headline)

                        Text(equipment.notes)
                            .font(.body)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(.horizontal, 24)
        }
        .navigationTitle(equipment.name)
        .navigationSubtitle(equipment.brand)
        .alert("Delete \(equipment.name)?", isPresented: $showDeleteConfirmation) {
            Button("Delete", role: .destructive) {
                do {
                    try equipmentUseCases.delete(equipment)
                    router.navigateBack()
                } catch {
                    alertCoordinator.show(error)
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will permanently delete this equipment.")
        }
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                if equipment.maintenanceTemplate == nil {
                    Button("Add Maintenance", systemImage: CJSymbol.Equipment.addMaintenance) {
                        openMaintenanceTemplate()
                    }
                } else {
                    Button("Add Maintenance", systemImage: CJSymbol.Equipment.maintenanceInstance) {
                        openMaintenanceTemplate()
                    }
                }
                
            }
            ToolbarItem(placement: .topBarTrailing) {
                Menu("Actions", systemImage: "ellipsis") {
                    Button("Edit Equipment", systemImage: CJSymbol.Action.edit) {
                        sheetCoordinator.present(.addEquipment(equipment))
                    }

                    Divider()

                    Button("Delete", systemImage: CJSymbol.Action.delete, role: .destructive) {
                        showDeleteConfirmation = true
                    }
                }
            }
        }
    }
    
    private func openMaintenanceTemplate() {
        if let template = equipment.maintenanceTemplate {
            sheetCoordinator.present(.maintenanceTemplate(template))
        } else {
            do {
                let template = try equipmentUseCases.createMaintenanceTemplate(equipment)
                sheetCoordinator.present(.maintenanceTemplate(template))
            } catch {
                alertCoordinator.show(error)
            }
        }
    }
}


#Preview(traits: .modifier(SampleDataModifier())) {
    @Previewable @Query var equipment: [Equipment]
    return NavigationStack {
        EquipmentDetailsView(equipment: equipment.first!)
    }
}
