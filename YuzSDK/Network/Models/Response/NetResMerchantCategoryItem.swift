//
//  NetResMerchantCategoryItem.swift
//  YuzPay
//
//  Created by applebro on 21/02/23.
//

import Foundation

public struct NetResMerchantCategoryItem: Codable, ModelProtocol {
    public let id: Int
    public let title: String
    public let order: Int
}
