//
//  Date+Extension.swift
//  YuzPay
//
//  Created by applebro on 11/12/22.
//

import Foundation

extension Date {
    static func formattedSeconds(_ dur: Double, _ shouldIncludeHours: Bool = true) -> String {
        let format = shouldIncludeHours ? "HH:mm:ss" : "mm:ss"
        return Date.init(timeIntervalSince1970: dur - 6 * 3600).toExtendedString(format: format)
    }
    
    func toExtendedString(format: String = "yyyy-MM-dd'T'HH:mm:ss.SSSXXX") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
