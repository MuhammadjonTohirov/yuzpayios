//
//  NetResCardItem.swift
//  YuzPay
//
//  Created by applebro on 16/04/23.
//

import Foundation

//{
//      "cardId": 0,
//      "cardNumber": "9973275050291192",
//      "cardHolder": "string",
//      "cardName": "string",
//      "expirationDate": "21/11",
//      "typeId": 0,
//      "statusCode": 0,
//      "isVirtual": true,
//      "balance": 0,
//      "createdTime": "2023-04-19T06:41:15.672Z",
//      "modefiedTime": "2023-04-19T06:41:15.672Z"
//    }

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
}
