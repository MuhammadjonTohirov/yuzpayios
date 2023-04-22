//
//  NetReqDoPayment.swift
//  YuzPay
//
//  Created by applebro on 22/04/23.
//

import Foundation

struct NetReqDoPayment: Codable {
    let cardId: Int
    let serviceId: Int
    let fields: [String: String]
    
    enum CodingKeys: String, CodingKey {
        case cardId = "card_id"
        case serviceId = "service_id"
        case fields
    }
}

