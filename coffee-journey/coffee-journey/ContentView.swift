//
//  ContentView.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 24.10.25.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.useCases) private var useCases
        
    var body: some View {
        TabView {
            Tab("Coffee", systemImage: "cup.and.heat.waves") {
                CoffeeShelfView()
            }
            Tab("Equipment", systemImage: "wrench.and.screwdriver") {
                EquipmentShelfView()
            }
            
            Tab(role: .search) {
                SearchView()
            }
        }
    }
}

#Preview {
    PreviewUseCaseEnvironment {
        ContentView()
    }
}
