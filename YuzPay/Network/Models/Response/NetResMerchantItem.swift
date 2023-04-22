//
//  NetResMerchantItem.swift
//  YuzPay
//
//  Created by applebro on 23/02/23.
//

import Foundation

struct NetResMerchantItem: Codable {
    let id: Int
    let title, logo: String
    let categoryId: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, title, logo
        case categoryId = "category_id"
    }
}
