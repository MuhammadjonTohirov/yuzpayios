//
//  NetReqDoPayment.swift
//  YuzPay
//
//  Created by applebro on 22/04/23.
//

import Foundation

public struct NetReqDoPayment: Codable {
    public let cardId: Int
    public let serviceId: Int
    public let fields: [String: String]
    
    enum CodingKeys: String, CodingKey {
        case cardId = "card_id"
        case serviceId = "service_id"
        case fields
    }
    
    public init(cardId: Int, serviceId: Int, fields: [String : String]) {
        self.cardId = cardId
        self.serviceId = serviceId
        self.fields = fields
    }
}

