//
//  NetReqAddCard.swift
//  YuzPay
//
//  Created by applebro on 16/04/23.
//

import Foundation

struct NetReqAddCard: Codable {
    var cardNumber: String = ""
    var cardName: String = ""
    var expirationDate: String = "" // format: 94/73 or MM/yy
    var type: Int = 0
    var isVirtual: Bool = false
}
