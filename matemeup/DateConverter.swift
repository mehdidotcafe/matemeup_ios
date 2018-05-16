//
//  Date.swift
//  matemeup
//
//  Created by Mehdi Meddour on 3/31/18.
//  Copyright © 2018 MateMeUp. All rights reserved.
//

import Foundation

class DateConverter {
    static func getFromStringUS(_ date: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        return dateFormatter.date(from: date)
    }
    
    static func getFromString(_ date: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-mm-yyyy"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        return dateFormatter.date(from: date)
    }
    
    static func toString(_ date: Date) -> String? {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
    }
    
    static func toStringUS(_ date: Date) -> String? {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: date)
    }
    
    static func getYear(_ date: Date) -> Int {
        let calendar = Calendar(identifier: .gregorian)
        return calendar.component(.year, from: date)
    }
    
    static func getMonth(_ date: Date) -> Int {
        let calendar = Calendar(identifier: .gregorian)
        return calendar.component(.month, from: date)
    }
    
    static func getDay(_ date: Date) -> Int {
        let calendar = Calendar(identifier: .gregorian)
        return calendar.component(.day, from: date)
    }
    
    static func getYearFromString(_ date: String) -> Int {
        return getYear(getFromString(date)!)
    }
    
    static func getMonthFromString(_ date: String) -> Int {
        return getMonth(getFromString(date)!)
    }
    
    static func getDayFromString(_ date: String) -> Int {
        return getDay(getFromString(date)!)
    }
}
