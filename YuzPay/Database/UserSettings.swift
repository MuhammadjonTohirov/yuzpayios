//
//  UserSettings.swift
//  YuzPay
//
//  Created by applebro on 11/12/22.
//

import Foundation
import SwiftKeychainWrapper

final public class UserSettings {
    public static let shared = UserSettings()
    
    @codableWrapper(key: "language")
    public var language: Language?
    
    @codableWrapper(key: "userInfo")
    public var userInfoDetails: UserInfoDetails?
    
    @anyWrapper(key: "isFillUserDetailsSkipped", defaultValue: false)
    public var isFillUserDetailsSkipped: Bool?
    
    @anyWrapper(key: "pincode", defaultValue: nil)
    public var appPin: String?
    
    @anyWrapper(key: "isIdentified", defaultValue: false)
    public var isVerifiedUser: Bool?
}
