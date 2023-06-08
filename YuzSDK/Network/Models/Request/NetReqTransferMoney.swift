//
//  NetReqTransferMoney.swift
//  YuzSDK
//
//  Created by applebro on 22/05/23.
//

import Foundation

public struct NetResTransferMoney: Codable {
    public let cardNumber: String?
    public let cardID: Int?
    public let amount: Float
    public let note: String?

    enum CodingKeys: String, CodingKey {
        case cardNumber
        case cardID = "cardId"
        case amount, note
    }
    
    public init(cardNumber: String?, cardID: Int?, amount: Float, note: String?) {
        self.cardNumber = cardNumber
        self.cardID = cardID
        self.amount = amount
        self.note = note
    }
}
