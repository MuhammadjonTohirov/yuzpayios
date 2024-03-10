//
//  NetReqP2P.swift
//  YuzSDK
//
//  Created by applebro on 28/05/23.
//

import Foundation

public struct NetReqP2P: Encodable {
    public let cardNumber: String?
    /// Humo, uzcard, visa, master
    public let type: Int? // uzcard = 0
    public let amount: Double
    public let note: String
    
    public init(cardNumber: String?, type: Int = 0, amount: Double, note: String) {
        self.cardNumber = cardNumber
        self.type = type
        self.amount = amount
        self.note = note
    }
}

public struct NetReqExchange: Encodable {
    public let targetId: Int
    public let amount: Double
    
    public init(targetId: Int, amount: Double) {
        self.targetId = targetId
        self.amount = amount
    }
}
