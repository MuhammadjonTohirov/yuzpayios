//
//  NetResMerchantItem.swift
//  YuzPay
//
//  Created by applebro on 23/02/23.
//

import Foundation

public struct NetResMerchantItem: Codable {
    public let id: Int
    public let title, logo: String
    public let categoryId: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, title, logo
        case categoryId = "category_id"
    }
}
