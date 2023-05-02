//
//  NetResAddCard.swift
//  YuzPay
//
//  Created by applebro on 19/04/23.
//

import Foundation

public struct NetResAddCard: NetResBody {
    public private(set) var token: String
    public private(set) var code: String
    public private(set) var cardId: Int
    
    public init(token: String, code: String, cardId: Int) {
        self.token = token
        self.code = code
        self.cardId = cardId
    }
}

