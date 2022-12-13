//
//  UserSettings.swift
//  YuzPay
//
//  Created by applebro on 11/12/22.
//

import Foundation

final public class UserSettings {
    public static let shared = UserSettings()
    
    @codableWrapper(key: "language")
    public var language: Language?
    
    @codableWrapper(key: "userInfo")
    public var userInfoDetails: UserInfoDetails?
    
    @anyWrapper(key: "isFillUserDetailsSkipped", defaultValue: false)
    public var isFillUserDetailsSkipped: Bool?
}
