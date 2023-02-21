//
//  Array+Extensions.swift
//  YuzPay
//
//  Created by applebro on 23/01/23.
//

import Foundation

extension Array {
    func item(at: Int) -> Element? {
        if self.count > at && at >= 0 {
            return self[at]
        }
        
        return nil
    }
    
    var nilIfEmpty: [Element]? {
        self.isEmpty ? nil : self
    }
    
    var nilOrEmpty: Bool {
        nilIfEmpty == nil
    }
}

extension Array: NetResBody where Element: Codable {
    
}