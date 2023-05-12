//
//  NetResTransactionItem.swift
//  YuzSDK
//
//  Created by applebro on 03/05/23.
//

import Foundation

public struct NetResTransactionItem: Codable {
    public let transactionId: Int
    public let transactionTime: Date
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
    
    enum CodingKeys: String, CodingKey {
        case transactionId = "transactionId"
        case transactionTime = "transactionTime"
        case amount = "amount"
        case note = "note"
        case transactionType = "transactionType"
        case cardId = "cardId"
        case exchangeCardId = "exchangeCardId"
        case exchangeType = "exchangeType"
        case exchangeAmount = "exchangeAmount"
        case p2PCardNumber = "p2PCardNumber"
        case p2PCardHolder = "p2PCardHolder"
        case p2PCardId = "p2PCardId"
        case commissionAmount = "commissionAmount"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.transactionId = try container.decode(Int.self, forKey: .transactionId)
        let _transactionTime = try? container.decode(String.self, forKey: .transactionTime)
        self.amount = try container.decode(Double.self, forKey: .amount)
        self.note = try? container.decodeIfPresent(String.self, forKey: .note)
        self.transactionType = try container.decode(Int.self, forKey: .transactionType)
        self.cardId = try container.decode(Int.self, forKey: .cardId)
        self.exchangeCardId = try? container.decodeIfPresent(Int.self, forKey: .exchangeCardId)
        self.exchangeType = try? container.decodeIfPresent(Int.self, forKey: .exchangeType)
        self.exchangeAmount = try? container.decodeIfPresent(Double.self, forKey: .exchangeAmount)
        self.p2PCardNumber = try? container.decodeIfPresent(String.self, forKey: .p2PCardNumber)
        self.p2PCardHolder = try? container.decodeIfPresent(String.self, forKey: .p2PCardHolder)
        self.p2PCardId = try? container.decodeIfPresent(Int.self, forKey: .p2PCardId)
        self.commissionAmount = try? container.decodeIfPresent(Double.self, forKey: .commissionAmount)
        
        if let _createdDateString = _transactionTime {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
            formatter.timeZone = .init(abbreviation: "GMT")
            self.transactionTime = formatter.date(from: _createdDateString) ?? Date()
        } else {
            self.transactionTime = Date()
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(transactionId, forKey: .transactionId)
        try container.encode(transactionTime, forKey: .transactionTime)
        try container.encode(amount, forKey: .amount)
        try container.encodeIfPresent(note, forKey: .note)
        try container.encode(transactionType, forKey: .transactionType)
        try container.encode(cardId, forKey: .cardId)
        try container.encodeIfPresent(exchangeCardId, forKey: .exchangeCardId)
        try container.encodeIfPresent(exchangeType, forKey: .exchangeType)
        try container.encodeIfPresent(exchangeAmount, forKey: .exchangeAmount)
        try container.encodeIfPresent(p2PCardNumber, forKey: .p2PCardNumber)
        try container.encodeIfPresent(p2PCardHolder, forKey: .p2PCardHolder)
        try container.encodeIfPresent(p2PCardId, forKey: .p2PCardId)
        try container.encodeIfPresent(commissionAmount, forKey: .commissionAmount)
    }

}
