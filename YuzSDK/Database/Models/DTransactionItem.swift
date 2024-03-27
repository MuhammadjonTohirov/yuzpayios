//
//  DTransactionItem.swift
//  YuzPay
//
//  Created by applebro on 01/01/23.
//

import Foundation
import RealmSwift

public final class DTransactionSection: Object, TransactionSectionProtocol {
    @Persisted(primaryKey: true) public var id: String
    @Persisted public var date: Date
    @Persisted public var items = List<DTransactionItem>()
    
    public var title: String {
        date.toExtendedString(format: Date.transactionSectionFormat)
    }
    
    public init(date: Date) {
        self.date = date
        super.init()
        self.id = DTransactionSection.primaryBy(date: date)
    }
    
    public override init() {
        super.init()
    }
    
    public static func primaryBy(date: Date) -> String {
        date.toExtendedString(format: Date.transactionSectionFormat)
    }
    
    public func add(item: DTransactionItem) {
        if let ditem = realm?.object(ofType: DTransactionItem.self, forPrimaryKey: item.id) {
            ditem.update(status: item.status)
            ditem.update(date: item.dateTime)
        } else {
            items.append(item)
        }
    }
}

public final class DTransactionItem: Object, TransactionItemProtocol {
    /// Transaction id
    @Persisted(primaryKey: true) public var id: String
    
    @Persisted public var agentName: String
    
    @Persisted public var status: TransactionStatus
    
    @Persisted public var amount: Float
    
    @Persisted public var currency: String
    
    @Persisted public var dateTime: Date
    
    @Persisted public var cardId: Int
    
    @Persisted public var type: TransactionType
    
    @Persisted public var exchangeCardId: Int?
    @Persisted public var exchangeType: Int?
    @Persisted public var exchangeAmount: Double?
    @Persisted public var p2PCardNumber: String?
    @Persisted public var p2PCardHolder: String?
    @Persisted public var p2PCardId: Int?
    @Persisted public var commissionAmount: Double?

    
    public init(id: String, agentName: String, status: TransactionStatus, amount: Float, currency: String, dateTime: Date, cardId: Int, type: TransactionType) {
        self.agentName = agentName
        self.status = status
        self.amount = amount
        self.currency = currency
        self.dateTime = dateTime
        self.cardId = cardId
        self.type = type
        super.init()

        self.id = id
    }
    
    public init(_ model: TransactionItem) {
        self.agentName = model.agentName
        self.status = model.status
        self.amount = model.amount
        self.currency = model.currency
        self.dateTime = model.dateTime
        self.cardId = model.cardId
        self.type = model.type
        self.exchangeCardId = model.exchangeCardId
        self.exchangeType = model.exchangeType
        self.exchangeAmount = model.exchangeAmount
        self.p2PCardNumber = model.p2PCardNumber
        self.p2PCardHolder = model.p2PCardHolder
        self.p2PCardId = model.p2PCardId
        self.commissionAmount = model.commissionAmount
        super.init()

        self.id = model.id
    
    }
    
    public override init() {
        super.init()
    }
    
    public func update(status: TransactionStatus) {
        self.status = status
    }
    
    public func update(date: Date) {
        self.dateTime = date
    }
}

public extension TransactionItem {
    static func createWith(_ ditem: DTransactionItem) -> TransactionItem {
        .init(id: ditem.id, agentName: ditem.agentName, status: ditem.status, amount: ditem.amount, currency: ditem.currency, dateTime: ditem.dateTime, cardId: ditem.cardId, type: ditem.type)
    }
}
