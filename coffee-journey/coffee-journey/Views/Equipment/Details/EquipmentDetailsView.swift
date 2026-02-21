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
    @Environment(\.router) private var router
    @Environment(\.equipmentUseCases) private var equipmentUseCases

    let equipment: Equipment

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
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu("Actions", systemImage: "ellipsis") {
                    Button("Edit", systemImage: "pencil") {
                        sheetCoordinator.present(.addEquipment(equipment))
                    }

                    Divider()

                    Button("Delete", systemImage: "trash", role: .destructive) {
                        try! equipmentUseCases.delete(equipment)
                        router.navigateBack()
                    }
                }
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
