//
//  Date+Extension.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 07.12.25.
//
import Foundation


extension Date {
    static var oneYearAgo: Date { Calendar.current.date(byAdding: .year, value: -1, to: Date())! }
    
    static var sixMonthsAgo: Date { Calendar.current.date(byAdding: .month, value: -6, to: Date())! }
    
    static var threeMonthsAgo: Date { Calendar.current.date(byAdding: .month, value: -3, to: Date())! }
    
    static var oneWeekAgo: Date { Calendar.current.date(byAdding: .day, value: -7, to: Date())! }
    
    static var twoWeekAgo: Date { Calendar.current.date(byAdding: .day, value: -14, to: Date())! }
}
