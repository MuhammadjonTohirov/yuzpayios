//
//  NetReqUpdateCard.swift
//  YuzPay
//
//  Created by applebro on 16/04/23.
//

import Foundation

public struct NetReqUpdateCard: Codable {
    public private(set) var cardName: String = ""
    public private(set) var isDefault: Bool = false
    
    public init(cardName: String, isDefault: Bool = false) {
        self.cardName = cardName
        self.isDefault = isDefault
    }
}
