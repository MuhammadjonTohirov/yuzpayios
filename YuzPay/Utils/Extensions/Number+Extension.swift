//
//  Number+Extension.swift
//  YuzPay
//
//  Created by applebro on 08/12/22.
//

import Foundation

public extension Double {
    func roundToDecimal(_ fractionDigits: Int) -> Double {
        let value = Int(self * 100)
        return Double(value) / 100
    }
    
    func asCurrency(_ locale: Locale = .current) -> String {
        Float(self).asCurrency(locale)
    }
}

public extension Double {
    func limitTop(_ n: Double) -> Double {
        return (self > n) ? n : self
    }
    
    func limitBottom(_ n: Double) -> Double {
        return (self < n) ? n : self
    }
    
    var f: CGFloat {
        CGFloat(self)
    }
}

public extension Int {
    func limitTop(_ n: Int) -> Int {
        return (self > n) ? n : self
    }
    
    func limitBottom(_ n: Int) -> Int {
        return (self < n) ? n : self
    }
    
    var f: CGFloat {
        CGFloat(self)
    }
}

public extension Int64 {
    func limitTop(_ n: Int64) -> Int64 {
        return (self > n) ? n : self
    }
    
    func limitBottom(_ n: Int64) -> Int64 {
        return (self < n) ? n : self
    }
    
    var f: CGFloat {
        CGFloat(self)
    }
}

public extension CGFloat {
    func limitTop(_ n: CGFloat) -> CGFloat {
        return (self > n) ? n : self
    }
    
    func limitBottom(_ n: CGFloat) -> CGFloat {
        return (self < n) ? n : self
    }
}

extension Float {
    func asCurrency(_ locale: Locale = .current) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "UZS"
        formatter.currencySymbol = ""
        formatter.locale = locale
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        formatter.locale = Locale(identifier: "uz_UZ")
        return formatter.string(from: NSNumber(value: self)) ?? ""
    }
}
