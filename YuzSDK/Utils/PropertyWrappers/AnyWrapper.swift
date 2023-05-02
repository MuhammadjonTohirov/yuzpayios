//
//  AnyWrapper.swift
//  YuzPay
//
//  Created by applebro on 11/12/22.
//

import Foundation

@propertyWrapper public struct anyWrapper<Value> {
    public let key: String
    public let storage: UserDefaults = UserDefaults.standard
    
    public init(key: String, defaultValue: Value?) {
        self.key = key
        self.wrappedValue = self.wrappedValue == nil ? defaultValue : self.wrappedValue
    }
    
    public var wrappedValue: Value? {
        get {
            storage.value(forKey: key) as? Value
        }
        
        set {
            storage.setValue(newValue, forKey: key)
        }
    }
}
