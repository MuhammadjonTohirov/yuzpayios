//
//  DInvoiceItem.swift
//  YuzPay
//
//  Created by applebro on 24/03/23.
//

import Foundation
import RealmSwift

final class DInvoiceItem: Object, DItemProtocol, Identifiable, InvoiceItemProtocol {
    var id: Int {
        invoiceID
    }
    
    @Persisted(primaryKey: true) var invoiceID: Int
    
    @Persisted var operatorName: String?
    
    @Persisted var branchName: String?
    
    @Persisted var organizationName: String?
    
    @Persisted var clientName: String?
    
    @Persisted var totalAmount: Int?
    
    @Persisted var invoiceNote: String?
    
    @Persisted var createdDate: String?
    
    @Persisted var isPaid: Bool?
    
    @Persisted var isExpired: Bool?
    
    init(invoiceID: Int, operatorName: String? = nil, branchName: String? = nil, organizationName: String? = nil, clientName: String? = nil, totalAmount: Int? = nil, invoiceNote: String? = nil, createdDate: String? = nil, isPaid: Bool? = nil, isExpired: Bool? = nil) {
        self.operatorName = operatorName
        self.branchName = branchName
        self.organizationName = organizationName
        self.clientName = clientName
        self.totalAmount = totalAmount
        self.invoiceNote = invoiceNote
        self.createdDate = createdDate
        self.isPaid = isPaid
        self.isExpired = isExpired
        
        super.init()
        
        self.invoiceID = invoiceID
    }
    
    override init() {
        super.init()
    }
    
    static func build(withModel model: InvoiceItemModel) -> any DItemProtocol {
        DInvoiceItem.init(invoiceID: model.invoiceID,
                          operatorName: model.operatorName,
                          branchName: model.branchName,
                          organizationName: model.organizationName,
                          clientName: model.clientName,
                          totalAmount: model.totalAmount,
                          invoiceNote: model.invoiceNote,
                          createdDate: model.createdDate,
                          isPaid: model.isPaid,
                          isExpired: model.isExpired)
    }
}
