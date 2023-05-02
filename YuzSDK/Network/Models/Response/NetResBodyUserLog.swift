//
//  NetResBodyUserLog.swift
//  YuzPay
//
//  Created by applebro on 18/02/23.
//

import SwiftUI

public struct NetResBodyUserLog: NotificationProtocol, NetResBody {
    public var id: Int {
        logID
    }
    
    public var logID: Int
    public var logTitle, createdDate: String?
    public var logStatus: Int?
    public var logDetails, userID: String?

    enum CodingKeys: String, CodingKey {
        case logID = "logId"
        case logTitle, createdDate, logStatus, logDetails
        case userID = "userId"
    }
}
