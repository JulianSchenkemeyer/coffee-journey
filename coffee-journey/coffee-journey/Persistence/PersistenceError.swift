//
//  PersistenceError.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 06.03.26.
//
import Foundation


enum PersistenceError: PresentableError {
    
    case insertFailed
    case updateFailed
    case deleteFailed
    case fetchFailed
    
    nonisolated var content: (title: String, description: String) {
        switch self {
        case .insertFailed:
            return (title: "Insert failed", description: "")
        case .updateFailed:
            return (title: "Update failed", description: "")
        case .deleteFailed:
            return (title: "Delete failed", description: "")
        case .fetchFailed:
            return (title: "Fetch failed", description: "")
        }
    }
}
