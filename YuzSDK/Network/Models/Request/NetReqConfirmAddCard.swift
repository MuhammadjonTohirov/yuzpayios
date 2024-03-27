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

public struct NetReqConfirmAddCard: Codable {
    public private(set) var code: String
        
    public init(code: String) {
        self.code = code
    }
    
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.code = try container.decode(String.self, forKey: .code)
    }
}
