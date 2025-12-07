//
//  Date+Extension.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 07.12.25.
//
import Foundation


extension Date {
    static var oneYearAgo: Date { Calendar.current.date(byAdding: .year, value: -1, to: Date())! }
}
