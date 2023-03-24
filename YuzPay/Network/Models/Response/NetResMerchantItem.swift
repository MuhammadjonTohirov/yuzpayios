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
    let services: [MerchantService]?
    let categoryId: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, title, logo, services
        case categoryId = "category_id"
    }
}

// MARK: - Service
struct MerchantService: Codable {
    let id, minAmount, maxAmount, childID: Int?
    let servicePrice, agentCommission, serviceCommission, order: Int?
    let serviceCommissionSum, paynetCommissionSum: Int?
    let title: String?
    let fields: [MerchantField]?
    let responseFields: [MerchantResponseField]?
    let services: [String]

    enum CodingKeys: String, CodingKey {
        case id, minAmount, maxAmount
        case childID = "childId"
        case servicePrice, agentCommission, serviceCommission, order, serviceCommissionSum, paynetCommissionSum, title, fields, responseFields, services
    }
}

// MARK: - Field
struct MerchantField: Codable {
    let id, order: Int?
    let name, title: String?
    let fieldRequired, readOnly: Bool?
    let fieldType: String?
    let isCustomerID: Bool?
    let fieldSize: Int?

    enum CodingKeys: String, CodingKey {
        case id, order, name, title
        case fieldRequired = "required"
        case readOnly, fieldType
        case isCustomerID = "isCustomerId"
        case fieldSize
    }
}

// MARK: - ResponseField
struct MerchantResponseField: Codable {
    let fieldName, label: String?
    let order: Int?
}
