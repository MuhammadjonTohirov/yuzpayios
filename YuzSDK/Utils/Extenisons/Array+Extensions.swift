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
    
    mutating func replace(item: Element, with newItem: Element) where Element: Hashable {
        if let index = self.firstIndex(of: item) {
            replace(itemAt: index, with: newItem)
        }
    }
    
    mutating func replace(itemAt index: Int, with newItem: Element) {
        self.remove(at: index)
        self.insert(newItem, at: index)
    }
}

extension Array: NetResBody where Element: Codable {
    
}
