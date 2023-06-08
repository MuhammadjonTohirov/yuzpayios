//
//  Date+Extensions.swift
//  YuzSDK
//
//  Created by applebro on 28/04/23.
//

import Foundation

public extension Date {
    static func formattedSeconds(_ dur: Double, _ shouldIncludeHours: Bool = true) -> String {
        let format = shouldIncludeHours ? "HH:mm:ss" : "mm:ss"
        return Date.init(timeIntervalSince1970: dur - 6 * 3600).toExtendedString(format: format)
    }
    
    static let transactionSectionFormat = "d MMM yyyy, E"
    
    static func from(string: String, format: String = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS", timezone: TimeZone? = .init(abbreviation: "GMT+5")) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = timezone
        return formatter.date(from: string)
    }
    
    func toExtendedString(format: String = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS", timezone: TimeZone? = .init(abbreviation: "GMT+5")) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = timezone
        return formatter.string(from: self)
    }
    
    var month: Int {
        
        return Int(self.toExtendedString(format: "MM"))!
    }
    
    var year: Int {
        return Int(self.toExtendedString(format: "YY"))!
    }
    
    func after(days: Int) -> Date {
        let date = Calendar.current.date(byAdding: DateComponents(day: days), to: self)
        return date ?? self
    }
        
    func after(monthes: Int) -> Date {
        let date = Calendar.current.date(byAdding: DateComponents(month: monthes), to: self)
        return date ?? self
    }
    
    func after(years: Int) -> Date {
        let date = Calendar.current.date(byAdding: DateComponents(year: years), to: self)
        return date ?? self
    }
    
    func before(days: Int) -> Date {
        after(days: -days)
    }
        
    func before(monthes: Int) -> Date {
        after(monthes: -monthes)
    }
    
    func before(years: Int) -> Date {
        after(years: -years)
    }
    
    /// Returns date object from string
    /// - Parameter txt: ex -> 10/24
    /// - Returns: Date object
    static func cardExpireDateToDateObject(_ txt: String) -> Date? {
        guard let month = Int(txt.components(separatedBy: "/").first ?? ""),
              let year = Int(txt.components(separatedBy: "/").last ?? "") else {
            return nil
        }
        
        if month > 12 {
            return nil
        }
        
        let currentMonthYear = Calendar.current.dateComponents([.month, .year], from: Date())
        
        guard let cy = currentMonthYear.year else {
            return nil
        }
    
        let dy = year - cy % 100
        
        if dy < 0 {
            return nil
        }
        
        let comingYear = dy + cy
        
        let newDateString = "12:12-01/\(month)/\(comingYear)"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "mm:HH-dd/MM/yyyy"

        return formatter.date(from: newDateString)
    }
    
    func dateToCardExpireString() -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/yy"
        
        return formatter.string(from: self)
    }
}
