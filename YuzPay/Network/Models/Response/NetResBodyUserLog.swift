//
//  NetResBodyUserLog.swift
//  YuzPay
//
//  Created by applebro on 18/02/23.
//

import SwiftUI

struct NetResBodyUserLog: NetResBody {
    let logID: Int
    let logTitle, createdDate: String
    let logStatus: Int
    let logDetails, userID: String

    enum CodingKeys: String, CodingKey {
        case logID = "logId"
        case logTitle, createdDate, logStatus, logDetails
        case userID = "userId"
    }
}
