//
//  NetResCardItem.swift
//  YuzPay
//
//  Created by applebro on 16/04/23.
//

import Foundation

public struct NetResCardItem: Identifiable, Encodable, NetResBody {
    public var id: Int {
        cardId
    }
    
    public var cardId: Int = 0
    public var clientId: String?
    public var cardNumber: String? = ""
    public var cardHolder: String? = ""
    public var cardName: String? = ""
    public var expirationDate: String? = "" // format: 94/73 or MM/yy
    public var statusCode: Int? = 0
    public var isVirtual: Bool = false
    public var balance: Double? = 0
    public var createdTime, modifiedTime: Date?
    public var isDefault: Bool
    public var typeID: Int?
    public var currencyId: Int?
    public var filterGroup: Int?
    public var isDeleted: Bool?
    
    enum CodingKeys: String, CodingKey {
        case cardID = "cardId"
        case clientID = "clientId"
        case cardNumber, cardHolder, cardName, expirationDate
        case typeID = "typeId"
        case statusCode, isVirtual, balance, createdTime, modifiedTime, isDefault
        case currencyID = "currencyId"
        case filterGroup, isDeleted
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.cardId = try container.decode(Int.self, forKey: .cardID)
        self.clientId = try? container.decodeIfPresent(String.self, forKey: .clientID)
        self.cardNumber = try? container.decodeIfPresent(String.self, forKey: .cardNumber)
        self.cardHolder = try? container.decodeIfPresent(String.self, forKey: .cardHolder)
        self.cardName = try? container.decodeIfPresent(String.self, forKey: .cardName)
        self.expirationDate = try? container.decodeIfPresent(String.self, forKey: .expirationDate)
        self.typeID = try? container.decodeIfPresent(Int.self, forKey: .typeID)
        self.statusCode = try? container.decodeIfPresent(Int.self, forKey: .statusCode)
        self.isVirtual = (try? container.decodeIfPresent(Bool.self, forKey: .isVirtual)) ?? false
        self.balance = try? container.decodeIfPresent(Double.self, forKey: .balance)
        self.isDefault = (try? container.decodeIfPresent(Bool.self, forKey: .isDefault)) ?? false
        self.currencyId = try? container.decodeIfPresent(Int.self, forKey: .currencyID)
        self.filterGroup = try? container.decodeIfPresent(Int.self, forKey: .filterGroup)
        self.isDeleted = (try? container.decodeIfPresent(Bool.self, forKey: .isDeleted)) ?? false
        
        let _createdTime = try? container.decodeIfPresent(String.self, forKey: .createdTime)
        let _modifiedTime = try? container.decodeIfPresent(String.self, forKey: .modifiedTime)
        createdTime = nil
        modifiedTime = nil
        if let _createdTime, let _modifiedTime {
            self.createdTime = Date.from(string: _createdTime, timezone: .init(abbreviation: "GMT")) ?? .now
            self.modifiedTime = Date.from(string: _modifiedTime, timezone: .init(abbreviation: "GMT")) ?? .now
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try? container.encode(cardId, forKey: .cardID)
        try? container.encode(clientId, forKey: .clientID)
        try? container.encode(cardNumber, forKey: .cardNumber)
        try? container.encode(cardHolder, forKey: .cardHolder)
        try? container.encode(cardName, forKey: .cardName)
        try? container.encode(expirationDate, forKey: .expirationDate)
        try? container.encode(typeID, forKey: .typeID)
        try? container.encode(statusCode, forKey: .statusCode)
        try? container.encode(isVirtual, forKey: .isVirtual)
        try? container.encode(balance, forKey: .balance)
        try? container.encode(isDefault, forKey: .isDefault)
        try? container.encode(currencyId, forKey: .currencyID)
        try? container.encode(filterGroup, forKey: .filterGroup)
        try? container.encode(isDeleted, forKey: .isDeleted)
        try? container.encode(createdTime?.toExtendedString(timezone: .init(abbreviation: "GMT")), forKey: .createdTime)
        try? container.encode(modifiedTime?.toExtendedString(timezone: .init(abbreviation: "GMT")), forKey: .modifiedTime)
    }
}
