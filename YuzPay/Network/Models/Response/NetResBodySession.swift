//
//  NetResBodySession.swift
//  YuzPay
//
//  Created by applebro on 18/02/23.
//

import SwiftUI

struct NetResBodySession: NetResBody {
    let sessionID: Int
    let userID, loginTime, clientIP, userAgent: String

    enum CodingKeys: String, CodingKey {
        case sessionID = "sessionId"
        case userID = "userId"
        case loginTime
        case clientIP = "clientIp"
        case userAgent
    }
}
