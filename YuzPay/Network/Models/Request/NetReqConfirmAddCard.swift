//
//  NetReqConfirmAddCard.swift
//  YuzPay
//
//  Created by applebro on 20/04/23.
//

import Foundation

//{
//  "token": "string",
//  "code": "string"
//}

struct NetReqConfirmAddCard: Codable {
    var token: String
    var code: String
}
