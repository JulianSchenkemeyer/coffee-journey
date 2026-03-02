//
//  View+Extension.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 08.02.26.
//
import Foundation
import SwiftUI



// MARK: - dismissMultiStepSheet environment key

private struct DismissMultiStepSheetKey: EnvironmentKey {
    static let defaultValue: () -> Void = {}
}

extension EnvironmentValues {
    var dismissMultiStepSheet: () -> Void {
        get { self[DismissMultiStepSheetKey.self] }
        set { self[DismissMultiStepSheetKey.self] = newValue }
    }
}

extension View {
    /// Injects a closure that dismisses the enclosing sheet from within a
    /// multi-step navigation flow, where @Environment(\.dismiss) would only
    /// pop the navigation stack instead of closing the sheet.
    func onDismissMultiStepSheet(_ action: @escaping () -> Void) -> some View {
        environment(\.dismissMultiStepSheet, action)
    }
}

// MARK: - Stretchy header modifier

extension View {
    func stretchy() -> some View {
        visualEffect { effect, geometry in
            let currentHeight = geometry.size.height
            let scrollOffset = geometry.frame(in: .scrollView).minY
            let positiveOffset = max(0, scrollOffset)
            
            let newHeight = currentHeight + positiveOffset
            let scaleFactor = newHeight / currentHeight
            
            return effect.scaleEffect(
                x: scaleFactor, y: scaleFactor,
                anchor: .bottom
            )
        }
    }
}

