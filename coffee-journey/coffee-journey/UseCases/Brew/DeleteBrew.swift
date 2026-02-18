//
//  DeleteBrew.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 17.02.26.
//

@MainActor struct DeleteBrew {
    let repository: BrewRepository

    
    func callAsFunction(brew: Brew) throws {
        try repository.delete(brew)
    }
}


