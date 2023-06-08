//
//  NSMutableData+Extensions.swift
//  YuzPay
//
//  Created by applebro on 16/02/23.
//

import Foundation

extension NSMutableData {
    func append(_ string: String) {
        if let data = string.data(using: String.Encoding.utf8) {
            append(data)
        }
    }
}

public extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8, allowLossyConversion: true) {
            append(data)
        }
    }
}
