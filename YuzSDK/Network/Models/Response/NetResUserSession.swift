//
//  NetResBodySession.swift
//  YuzPay
//
//  Created by applebro on 18/02/23.
//

import SwiftUI

public struct NetResUserSession: NetResBody, UserSessionProtocol {
    public var id: Int {
        sessionID
    }
    
    public var sessionID: Int
    public var userID, loginTime, clientIP, userAgent: String

    enum CodingKeys: String, CodingKey {
        case sessionID = "sessionId"
        case userID = "userId"
        case loginTime
        case clientIP = "clientIp"
        case userAgent
    }
}
