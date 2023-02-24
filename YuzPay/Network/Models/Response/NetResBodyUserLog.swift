//
//  NetResBodyUserLog.swift
//  YuzPay
//
//  Created by applebro on 18/02/23.
//

import SwiftUI

struct NetResBodyUserLog: NotificationProtocol, NetResBody {
    var id: Int {
        logID
    }
    
    var logID: Int
    var logTitle, createdDate: String?
    var logStatus: Int?
    var logDetails, userID: String?

    enum CodingKeys: String, CodingKey {
        case logID = "logId"
        case logTitle, createdDate, logStatus, logDetails
        case userID = "userId"
    }
}
