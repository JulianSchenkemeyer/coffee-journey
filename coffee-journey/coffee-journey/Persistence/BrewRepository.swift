//
//  BrewRepository.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 18.02.26.
//
import Foundation
import SwiftData


protocol BrewRepository {
    func update(_ brew: Brew) throws -> Brew
    func delete(_ brew: Brew) throws
}


@MainActor
final class SwiftDataBrewRepository: BrewRepository {
    private let context: ModelContext
    init(context: ModelContext) { self.context = context }
    
    func update(_ brew: Brew) throws -> Brew {
        try context.save()
        
        return brew
    }
    
    func delete(_ brew: Brew) throws {
        context.delete(brew)
        try context.save()
    }
}
