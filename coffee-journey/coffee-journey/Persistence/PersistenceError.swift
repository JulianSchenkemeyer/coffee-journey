//
//  PersistenceError.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 06.03.26.
//
import Foundation


enum PersistenceError: LocalizedError {
    case insertFailed
    case updateFailed
    case deleteFailed
    case fetchFailed
    
    var errorDescription: String? {
        //TODO: improve description
        switch self {
        case .insertFailed:
            return "Insert failed"
        case .updateFailed:
            return "Update failed"
        case .deleteFailed:
            return "Delete failed"
        case .fetchFailed:
            return "Fetch failed"
        }
    }
}
