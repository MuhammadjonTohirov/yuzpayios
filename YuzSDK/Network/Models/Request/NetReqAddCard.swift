//
//  NetReqAddCard.swift
//  YuzPay
//
//  Created by applebro on 16/04/23.
//

import Foundation

public struct NetReqAddCard: Codable {
    public var cardNumber: String = ""
    public var cardName: String = ""
    public var expirationDate: String = "" // format: 94/73 or MM/yy
    public var type: Int = 0
    public var isVirtual: Bool = false
    
    public init(cardNumber: String, cardName: String, expirationDate: String, type: Int = 0, isVirtual: Bool = false) {
        self.cardNumber = cardNumber
        self.cardName = cardName
        self.expirationDate = expirationDate
        self.type = type
        self.isVirtual = isVirtual
    }
}
