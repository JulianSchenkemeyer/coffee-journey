//
//  SearchableModel.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 31.01.26.
//
import Foundation
import SwiftData


protocol SearchableModel: PersistentModel {
    static func search(for term: String) -> Predicate<Self>?
}
