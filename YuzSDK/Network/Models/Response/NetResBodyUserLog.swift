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
    public var logTitle: String?
    public var createdDate: Date?
    public var logStatus: Int?
    public var logDetails, userID: String?

    enum CodingKeys: String, CodingKey {
        case logID = "logId"
        case logTitle, createdDate, logStatus, logDetails
        case userID = "userId"
    }
    
    public init(logID: Int, logTitle: String? = nil, createdDate: Date? = nil, logStatus: Int? = nil, logDetails: String? = nil, userID: String? = nil) {
        self.logID = logID
        self.logTitle = logTitle
        self.createdDate = createdDate
        self.logStatus = logStatus
        self.logDetails = logDetails
        self.userID = userID
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        logID = try container.decode(Int.self, forKey: .logID)
        logTitle = try container.decodeIfPresent(String.self, forKey: .logTitle)
        let _createdDate = try container.decodeIfPresent(String.self, forKey: .createdDate)
        logStatus = try container.decodeIfPresent(Int.self, forKey: .logStatus)
        logDetails = try container.decodeIfPresent(String.self, forKey: .logDetails)
        userID = try container.decodeIfPresent(String.self, forKey: .userID)
        
        self.createdDate = Date.from(string: _createdDate ?? "")
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(logID, forKey: .logID)
        try container.encodeIfPresent(logTitle, forKey: .logTitle)
        try container.encodeIfPresent(createdDate, forKey: .createdDate)
        try container.encodeIfPresent(logStatus, forKey: .logStatus)
        try container.encodeIfPresent(logDetails, forKey: .logDetails)
        try container.encodeIfPresent(userID, forKey: .userID)
    }
}
