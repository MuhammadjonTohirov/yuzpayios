//
//  NetResMerchantCategoryItem.swift
//  YuzPay
//
//  Created by applebro on 21/02/23.
//

import Foundation

struct NetResMerchantCategoryItem: Codable, ModelProtocol {
    let id: Int
    let title: String
    let order: Int
}
