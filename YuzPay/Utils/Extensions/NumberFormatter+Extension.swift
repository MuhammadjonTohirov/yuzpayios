//
//  NumberFormatter+Extension.swift
//  YuzPay
//
//  Created by applebro on 21/04/23.
//

import Foundation

extension NumberFormatter {
    static func moneyFormatter(_ symbol: String = "sum") -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = symbol
        formatter.maximumFractionDigits = 0
        return formatter
    
    }
}
