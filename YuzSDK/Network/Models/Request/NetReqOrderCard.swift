//
//  NetReqOrderCard.swift
//  YuzSDK
//
//  Created by applebro on 12/05/23.
//

import Foundation

public struct NetReqOrderCard: Codable {
    let regionID, district: Int
    let street, address, note: String
    let bankID, type: Int

    enum CodingKeys: String, CodingKey {
        case regionID = "regionId"
        case district, street, address, note
        case bankID = "bankId"
        case type
    }
    
    public init(regionID: Int, district: Int, street: String, address: String, note: String, bankID: Int, type: Int) {
        self.regionID = regionID
        self.district = district
        self.street = street
        self.address = address
        self.note = note
        self.bankID = bankID
        self.type = type
    }
}

