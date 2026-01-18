//
//  DateHelper.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 17.01.26.
//
import Foundation


#if DEBUG

enum DateHelper {
    static func daysAgo(_ daysAgo: Int, hour: Int, minute: Int) -> Date {
        let base = Calendar.current.date(byAdding: .day, value: -daysAgo, to: Date()) ?? Date()
        return Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: base)!
    }
}

#endif
