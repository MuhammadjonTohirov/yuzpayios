//
//  Array+Extensions.swift
//  YuzSDK
//
//  Created by applebro on 28/04/23.
//

import Foundation

public extension Array {
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
