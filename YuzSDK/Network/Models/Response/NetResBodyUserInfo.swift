//
//  NetResBodyUserInfo.swift
//  YuzPay
//
//  Created by applebro on 18/02/23.
//

import SwiftUI

public struct NetResBodyUserInfo: NetResBody {
    public let userID, userName: String?
    public let isVerified: Bool?
    public let dateOfBirth, fullName, phoneNumber: String?
    public let phoneConfirmed: Bool?
    public let passportNumber: String?
    public let regionID: Int?
    public let regionName: String?
    public let districtID: Int?
    public let districtName, address: String?
    public let organizationID: Int?
    public let organizationName, cashierDevice: String?
    
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case userName, isVerified, dateOfBirth, fullName, phoneNumber, phoneConfirmed, passportNumber
        case regionID = "regionId"
        case regionName
        case districtID = "districtId"
        case districtName, address
        case organizationID = "organizationId"
        case organizationName, cashierDevice
    }
}
