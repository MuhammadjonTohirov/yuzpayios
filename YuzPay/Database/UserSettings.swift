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
    
    public private(set) var userAvatarURL: URL = URL.base.appendingPath("img", "Client", "ProfileAvatar.png")
    
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
    
    @anyWrapper(key: "userPhoneNumber", defaultValue: nil)
    public var userPhone: String?
    
    @anyWrapper(key: "checkPhoneToken", defaultValue: nil)
    public var checkPhoneToken: String?

    @anyWrapper(key: "accessToken", defaultValue: nil)
    public var accessToken: String?

    @anyWrapper(key: "refreshToken", defaultValue: nil)
    public var refreshToken: String?
    
    @anyWrapper(key: "accessTokenExpire", defaultValue: nil)
    public var accessTokenExpireDate: Double?

    @anyWrapper(key: "refresTokenExpire", defaultValue: nil)
    public var refresTokenExpireDate: Double?
    
    @anyWrapper(key: "lastOTP", defaultValue: nil)
    public var lastOTP: String?
    
    func clearUserDetails() {
        self.accessToken = nil
        self.accessTokenExpireDate = nil
        self.refreshToken = nil
        self.refresTokenExpireDate = nil
        
        self.lastOTP = nil
        self.userPhone = nil
        self.checkPhoneToken = nil
        self.isVerifiedUser = nil
        self.appPin = nil
    }
}
