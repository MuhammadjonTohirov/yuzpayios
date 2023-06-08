//
//  NetReqP2P.swift
//  YuzSDK
//
//  Created by applebro on 28/05/23.
//

import Foundation

public struct NetReqP2P: Encodable {
    public let cardNumber: String?
    public let cardId: Int?
    public let amount: Double
    public let note: String
    
    public init(cardNumber: String?, cardId: Int?, amount: Double, note: String) {
        self.cardNumber = cardNumber
        self.cardId = cardId
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
