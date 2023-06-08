//
//  NetResAddress.swift
//  YuzSDK
//
//  Created by applebro on 11/05/23.
//

import Foundation

public struct NetResRegion: Codable, NetResBody {
    public private(set) var regionId: Int
    public private(set) var regionName: String
    public private(set) var regionCode: String?
    public private(set) var regionNumber: Int?
}

public struct NetResDistrict: Codable, NetResBody {
    public private(set) var districtId: Int
    public private(set) var districtName: String
    public private(set) var districtCode: String?
    public private(set) var districtNumber: Int?
    public private(set) var regionId: Int
}
