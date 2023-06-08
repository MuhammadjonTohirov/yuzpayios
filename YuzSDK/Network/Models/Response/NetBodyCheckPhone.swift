//
//  NetBodyCheckPhone.swift
//  YuzPay
//
//  Created by applebro on 15/02/23.
//

import Foundation

public struct NetBodyCheckPhone: NetResBody {
    public let exists: Bool
    public let token: String
    public let code: String // stands for otp
    
    public init(exists: Bool, token: String, code: String) {
        self.exists = exists
        self.token = token
        self.code = code
    }
    
}
