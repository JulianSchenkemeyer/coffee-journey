//
//  ResultRowRenderer.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 31.01.26.
//
import Foundation
import SwiftUI

protocol ResultRowRenderer {
    associatedtype Model: SearchableModel
    associatedtype Row: View
    @ViewBuilder func row(for model: Model) -> Row
}

struct CoffeeRowRenderer: ResultRowRenderer {
    func row(for model: Coffee) -> some View {
        CoffeeShelfEntryView(coffee: model)
    }
}

struct EquipmentRowRenderer: ResultRowRenderer {
    func row(for model: Equipment) -> some View {
        Text(model.name)
    }
}
