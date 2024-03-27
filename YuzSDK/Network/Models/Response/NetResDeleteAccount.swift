//
//  NetResDeleteAccount.swift
//  YuzSDK
//
//  Created by applebro on 05/06/23.
//

import Foundation

public struct NetResDeleteAccount: Codable, NetResBody {
    public var code: String
    public var token: String
    
    public init(code: String, token: String) {
        self.code = code
        self.token = token
    }
}

public struct NetReqConfirmDeleteAccount: Codable {
    public var code: String
    public var token: String
    
    public init(code: String, token: String) {
        self.code = code
        self.token = token
    }
}

