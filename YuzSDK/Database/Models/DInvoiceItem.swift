//
//  DInvoiceItem.swift
//  YuzPay
//
//  Created by applebro on 24/03/23.
//

import Foundation
import RealmSwift

final public class DInvoiceItem: Object, DItemProtocol, Identifiable, InvoiceItemProtocol {
    public var id: Int {
        invoiceID
    }
    
    @Persisted(primaryKey: true) public var invoiceID: Int
    
    @Persisted public var operatorName: String?
    
    @Persisted public var branchName: String?
    
    @Persisted public var organizationName: String?
    
    @Persisted public var clientName: String?
    
    @Persisted public var totalAmount: Float?
    
    @Persisted public var invoiceNote: String?
    
    @Persisted public var createdDate: Date?
    
    @Persisted public var isPaid: Bool?
    
    @Persisted public var isExpired: Bool?
    
    public init(invoiceID: Int, operatorName: String? = nil, branchName: String? = nil, organizationName: String? = nil, clientName: String? = nil, totalAmount: Float? = nil, invoiceNote: String? = nil, createdDate: Date? = nil, isPaid: Bool? = nil, isExpired: Bool? = nil) {
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
    
    public override init() {
        super.init()
    }
    
    public static func build(withModel model: InvoiceItemModel) -> any DItemProtocol {
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
