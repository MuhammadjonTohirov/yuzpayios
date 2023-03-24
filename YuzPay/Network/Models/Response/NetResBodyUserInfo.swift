//
//  NetResBodyUserInfo.swift
//  YuzPay
//
//  Created by applebro on 18/02/23.
//

import SwiftUI

struct NetResBodyUserInfo: NetResBody {
    let userID, userName: String?
    let isVerified: Bool?
    let dateOfBirth, fullName, phoneNumber: String?
    let phoneConfirmed: Bool?
    let passportNumber: String?
    let regionID: Int?
    let regionName: String?
    let districtID: Int?
    let districtName, address: String?
    let organizationID: Int?
    let organizationName, cashierDevice: String?
    
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
