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
            CoffeeShelfView()
                .tabItem {
                    Label("Coffee", systemImage: "cup.and.heat.waves")
                }
            EquipmentShelfView()
                .tabItem {
                    Label("Equipment", systemImage: "wrench.and.screwdriver")
                }
        }
    }
}

#Preview {
    PreviewUseCaseEnvironment {
        ContentView()
    }
}
