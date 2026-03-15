//
//  SymbolConstants.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 15.03.26.
//

enum CJSymbol {
    enum Navigation {
        static let brewHistory = "square.stack.fill"
        static let coffee = "cup.and.heat.waves"
        static let equipment = "wrench.and.screwdriver"
    }
    
    enum Action {
        static let add = "plus"
        static let edit = "pencil"
        static let calibrate = "target"
        static let recalibrate = "gearshape.arrow.trianglehead.2.clockwise.rotate.90"
        static let refill = "arrow.trianglehead.clockwise"
        static let brew = "cup.and.heat.waves.fill"
        static let clear = "clear"
        static let delete = "trash"
    }
    
    enum Coffee {
        static let roasted = "flame.fill"
        static let refilled = "arrow.trianglehead.clockwise"
        static let brew = "cup.and.heat.waves.fill"
        static let rating = "star.fill"
    }
    
    enum Equipment {
        static let type = "tag.fill"
        static let brand = "building.2.fill"
    }
}
