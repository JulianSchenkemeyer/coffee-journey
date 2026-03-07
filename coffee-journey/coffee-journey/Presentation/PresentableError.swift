//
//  PresentableError.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 06.03.26.
//
import Foundation


protocol PresentableError: LocalizedError {
    var content: (title: String, description: String) { get }
}

// Provide convience helper to quickly access tuple properties
extension PersistenceError {
    nonisolated var title: String {
        self.content.title
    }
    
    nonisolated var errorDescription: String? {
        self.content.description
    }
}
