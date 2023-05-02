//
//  InvoiceItemModel.swift
//  YuzPay
//
//  Created by applebro on 24/03/23.
//

import Foundation
import YuzSDK

protocol InvoiceItemProtocol: ModelProtocol {
    var invoiceID: Int {get set}
    var operatorName: String? {get set}
    var branchName: String? {get set}
    var organizationName: String? {get set}
    var clientName: String? {get set}
    var totalAmount: Int? {get set}
    var invoiceNote: String? {get set}
    var createdDate: String? {get set}
    var isPaid: Bool? {get set}
    var isExpired: Bool? {get set}
}


struct InvoiceItemModel: ModelProtocol, InvoiceItemProtocol {
    var id: Int {
        invoiceID
    }
    
    var invoiceID: Int
    var operatorName, branchName, organizationName, clientName: String?
    var totalAmount: Int?
    var invoiceNote, createdDate: String?
    var isPaid, isExpired: Bool?
    
    init(invoiceID: Int, operatorName: String? = nil, branchName: String? = nil, organizationName: String? = nil, clientName: String? = nil, totalAmount: Int? = nil, invoiceNote: String? = nil, createdDate: String? = nil, isPaid: Bool? = nil, isExpired: Bool? = nil) {
        self.invoiceID = invoiceID
        self.operatorName = operatorName
        self.branchName = branchName
        self.organizationName = organizationName
        self.clientName = clientName
        self.totalAmount = totalAmount
        self.invoiceNote = invoiceNote
        self.createdDate = createdDate
        self.isPaid = isPaid
        self.isExpired = isExpired
    }
    
    static func create(res: NetResInvoiceItem) -> InvoiceItemModel {
        .init(invoiceID: res.invoiceID,
              operatorName: res.operatorName,
              branchName: res.branchName,
              organizationName: res.organizationName,
              clientName: res.clientName,
              totalAmount: res.totalAmount,
              invoiceNote: res.invoiceNote,
              createdDate: res.createdDate,
              isPaid: res.isPaid, isExpired: res.isExpired)
    }
}

