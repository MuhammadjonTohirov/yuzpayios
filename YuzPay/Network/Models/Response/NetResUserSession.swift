//
//  NetResBodySession.swift
//  YuzPay
//
//  Created by applebro on 18/02/23.
//

import SwiftUI

struct NetResUserSession: NetResBody, UserSessionProtocol {
    var id: Int {
        sessionID
    }
    
    var sessionID: Int
    var userID, loginTime, clientIP, userAgent: String

    enum CodingKeys: String, CodingKey {
        case sessionID = "sessionId"
        case userID = "userId"
        case loginTime
        case clientIP = "clientIp"
        case userAgent
    }
}
