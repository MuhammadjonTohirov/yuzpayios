//
//  NetResTransactionItem.swift
//  YuzSDK
//
//  Created by applebro on 03/05/23.
//

import Foundation

public struct NetResTransactionItem: Codable {
    public let transactionId: Int
    public let transactionTime: String
    public let amount: Double
    public let note: String?
    public let transactionType: Int
    public let cardId: Int
    public let exchangeCardId: Int?
    public let exchangeType: Int?
    public let exchangeAmount: Double?
    public let p2PCardNumber: String?
    public let p2PCardHolder: String?
    public let p2PCardId: Int?
    public let commissionAmount: Double?
}
