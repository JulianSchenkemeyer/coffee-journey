//
//  UpdateBrew.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 18.02.26.
//

@MainActor struct UpdateBrew {
    let repository: BrewRepository

    @discardableResult
    func callAsFunction(brew: Brew) throws -> Brew {
        try repository.update(brew)
    }
}
