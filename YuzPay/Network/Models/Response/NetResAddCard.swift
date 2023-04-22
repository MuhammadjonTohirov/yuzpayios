//
//  NetResAddCard.swift
//  YuzPay
//
//  Created by applebro on 19/04/23.
//

import Foundation

struct NetResAddCard: NetResBody {
    var token: String
    var code: String
    var cardId: Int
}

