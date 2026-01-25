//
//  Double+Extension.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 20.01.26.
//
import Foundation


extension Double {
    nonisolated func roundTo(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
