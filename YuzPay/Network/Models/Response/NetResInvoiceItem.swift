//
//  NetResInvoiceItem.swift
//  YuzPay
//
//  Created by applebro on 24/03/23.
//

import Foundation

struct NetResInvoiceItem: Codable {
    let invoiceID: Int
    let operatorName, branchName, organizationName, clientName: String?
    let totalAmount: Int?
    let invoiceNote, createdDate: String?
    let isPaid, isExpired: Bool?

    enum CodingKeys: String, CodingKey {
        case invoiceID = "invoiceId"
        case operatorName, branchName, organizationName, clientName, totalAmount, invoiceNote, createdDate, isPaid, isExpired
    }
}

