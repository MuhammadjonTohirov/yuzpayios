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
