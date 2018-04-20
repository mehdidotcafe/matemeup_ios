//
//  Date.swift
//  matemeup
//
//  Created by Mehdi Meddour on 3/31/18.
//  Copyright © 2018 MateMeUp. All rights reserved.
//

import Foundation

class DateConverter {
    static func getFromString(_ date: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-mm-yyyy" //Your date format
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00") //Current time zone
        return dateFormatter.date(from: date) //according to date format your date string
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
