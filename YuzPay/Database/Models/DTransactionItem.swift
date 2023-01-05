//
//  DTransactionItem.swift
//  YuzPay
//
//  Created by applebro on 01/01/23.
//

import Foundation
import RealmSwift

final class DTransactionSection: Object, TransactionSectionProtocol {
    @Persisted(primaryKey: true) var id: String
    @Persisted var date: Date
    @Persisted var items = List<DTransactionItem>()
    
    var title: String {
        date.toExtendedString(format: Date.transactionSectionFormat)
    }
    
    init(date: Date) {
        self.date = date
        super.init()
        self.id = DTransactionSection.primaryBy(date: date)
    }
    
    override init() {
        super.init()
    }
    
    static func primaryBy(date: Date) -> String {
        date.toExtendedString(format: Date.transactionSectionFormat)
    }
    
    func add(item: DTransactionItem) {
        if let ditem = realm?.object(ofType: DTransactionItem.self, forPrimaryKey: item.id) {
            ditem.update(status: item.status)
        } else {
            items.append(item)
        }
    }
}

final class DTransactionItem: Object, TransactionItemProtocol {
    /// Transaction id
    @Persisted(primaryKey: true) var id: String
    
    @Persisted var agentName: String
    
    @Persisted var status: TransactionStatus
    
    @Persisted var amount: Float
    
    @Persisted var currency: String
    
    @Persisted var dateTime: Date
    
    init(id: String, agentName: String, status: TransactionStatus, amount: Float, currency: String, dateTime: Date) {
        self.agentName = agentName
        self.status = status
        self.amount = amount
        self.currency = currency
        self.dateTime = dateTime
        
        super.init()

        self.id = id
    }
    
    init(_ model: TransactionItem) {
        self.status = model.status
        self.amount = model.amount
        self.agentName = model.agentName
        self.currency = model.currency
        self.dateTime = model.dateTime
        super.init()
        self.id = model.id
    }
    
    override init() {
        super.init()
    }
    
    func update(status: TransactionStatus) {
        self.status = status
    }
}

extension TransactionItem {
    static func createWith(_ ditem: DTransactionItem) -> TransactionItem {
        .init(id: ditem.id, agentName: ditem.agentName, status: ditem.status, amount: ditem.amount, currency: ditem.currency, dateTime: ditem.dateTime)
    }
}
