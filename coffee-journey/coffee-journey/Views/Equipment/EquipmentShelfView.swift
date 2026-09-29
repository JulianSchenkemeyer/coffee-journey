//
//  EquipmentShelfView.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 17.11.25.
//

//
//  CoffeeShelfView.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 01.11.25.
//

import Foundation
import SwiftUI
import SwiftData


struct EquipmentShelfView: View {
    @Environment(\.router) private var router
    @Environment(\.sheetCoordinator) private var sheetCoordinator
    @Environment(\.sheetNamespace) private var sheetNamespace
    /// Previews only — the environment value is nil outside SheetCoordinatorView.
    @Namespace private var fallbackSheetNamespace

    @State private var searchTerm = ""

    @Query var equipment: [Equipment] = []
    
    var body: some View {
        @Bindable var router = router

        NavigationSplitView {
            Group {
                if searchTerm.isEmpty {
                    shelf(selection: $router.selection)
                } else {
                    // Queries the store through `Equipment.search(for:)`, so results are flat
                    // rather than grouped by type.
                    SearchResultsView(searchTerm: searchTerm,
                                      renderer: EquipmentRowRenderer(),
                                      selection: $router.selection)
                }
            }
            .navigationTitle("Equipment Shelf")
            .searchable(text: $searchTerm, placement: .navigationBarDrawer, prompt: "Search Equipment")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add Equipment", systemImage: CJSymbol.Action.add) {
                        sheetCoordinator.present(.addEquipment(nil), from: .addEquipment)
                    }
                }
                .sheetZoomSource(.addEquipment, in: sheetNamespace ?? fallbackSheetNamespace)
            }
        } detail: {
            RouterView()
        }
    }

    private func shelf(selection: Binding<Router.Route?>) -> some View {
        let groupedEquipment = Dictionary(grouping: equipment, by: \.type)

        return List(EquipmentType.allCases, id: \.self, selection: selection) { type in
            if let items = groupedEquipment[type] {
                Section(type.description.capitalized) {
                    ForEach(items) { item in
                        RouteLink(.equipmentDetails(item)) {
                            EquipmentShelfEntryView(equipment: item)
                        }
                    }
                }
            }
        }
    }
}


#Preview(traits: .modifier(SampleDataModifier())) {
    EquipmentShelfView()
}
