//
//  ContentView.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 24.10.25.
//

import SwiftUI

struct ContentView: View {
    // Each tab gets its own independent router instance, scoped via .environment below.
    // This ensures navigation state is isolated per tab.
    private let coffeeRouter = Router()
    private let equipmentRouter = Router()
    private let searchRouter = Router()

    var body: some View {
        SheetCoordinatorView {
            TabView {
                Tab("Coffee", systemImage: "cup.and.heat.waves") {
                    CoffeeShelfView()
                        .environment(\.router, coffeeRouter)
                }
                Tab("Equipment", systemImage: "wrench.and.screwdriver") {
                    EquipmentShelfView()
                        .environment(\.router, equipmentRouter)
                }

                Tab(role: .search) {
                    SearchView()
                        .environment(\.router, searchRouter)
                }
            }
        }
    }
}

#Preview {
    PreviewUseCaseEnvironment {
        ContentView()
    }
}
