//
//  KeychainWrapper.swift
//  YuzPay
//
//  Created by applebro on 19/12/22.
//

import Foundation
import SwiftKeychainWrapper

@propertyWrapper public struct yKeychainWrapper {
    public let key: String
    
    public init(key: String) {
        self.key = key
    }
    
    public var wrappedValue: String? {
        get {
            return KeychainWrapper.standard.string(forKey: .custom(key))
        }
        
        set {
            if let val = newValue {
                KeychainWrapper.standard.set(
                    val,
                    forKey: key,
                    withAccessibility: .alwaysThisDeviceOnly
                )
            } else {
                KeychainWrapper.standard.remove(forKey: .custom(key))
            }
        }
    }
}


extension KeychainWrapper.Key {
    static func custom(_ key: String) -> KeychainWrapper.Key { return KeychainWrapper.Key.init(stringLiteral: key) }
}
