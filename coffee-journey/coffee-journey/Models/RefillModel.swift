//
//  RefillModel.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 23.11.25.
//

import Foundation
import SwiftData


@Model final class Refill {
    var coffee: Coffee?
    var amount: Double
    var roastDate: Date
    var date: Date
    
    
    init(amount: Double, roastDate: Date, date: Date) {
        self.amount = amount
        self.roastDate = roastDate
        self.date = date
    }
}
