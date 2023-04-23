//
//  NetResCardItem.swift
//  YuzPay
//
//  Created by applebro on 16/04/23.
//

import Foundation

struct NetResCardItem: Identifiable, Codable, NetResBody {
    var id: Int {
        cardId
    }
    
    var cardId: Int = 0
    var cardNumber: String? = ""
    var cardHolder: String? = ""
    var cardName: String? = ""
    var expirationDate: String? = "" // format: 94/73 or MM/yy
    var type: Int? = 0
    var statusCode: Int? = 0
    var isVirtual: Bool = false
    var balance: Double? = 0
    var createdTime: String? = ""
    var modifiedTime: String? = ""
    var isDefault: Bool
}
