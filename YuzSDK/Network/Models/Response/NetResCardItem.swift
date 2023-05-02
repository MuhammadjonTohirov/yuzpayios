//
//  NetResCardItem.swift
//  YuzPay
//
//  Created by applebro on 16/04/23.
//

import Foundation

public struct NetResCardItem: Identifiable, Codable, NetResBody {
    public var id: Int {
        cardId
    }
    
    public var cardId: Int = 0
    public var cardNumber: String? = ""
    public var cardHolder: String? = ""
    public var cardName: String? = ""
    public var expirationDate: String? = "" // format: 94/73 or MM/yy
    public var type: Int? = 0
    public var statusCode: Int? = 0
    public var isVirtual: Bool = false
    public var balance: Double? = 0
    public var createdTime: String? = ""
    public var modifiedTime: String? = ""
    public var isDefault: Bool
}
