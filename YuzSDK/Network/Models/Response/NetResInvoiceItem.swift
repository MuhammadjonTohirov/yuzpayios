//
//  NetResInvoiceItem.swift
//  YuzPay
//
//  Created by applebro on 24/03/23.
//

import Foundation

public struct NetResInvoiceItem: Codable {
    public let invoiceID: Int
    public let operatorName, branchName, organizationName, clientName: String?
    public let totalAmount: Int?
    public let invoiceNote, createdDate: String?
    public let isPaid, isExpired: Bool?

    enum CodingKeys: String, CodingKey {
        case invoiceID = "invoiceId"
        case operatorName, branchName, organizationName, clientName, totalAmount, invoiceNote, createdDate, isPaid, isExpired
    }
}

