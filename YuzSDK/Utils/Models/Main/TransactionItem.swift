//
//  TransactionItem.swift
//  YuzPay
//
//  Created by applebro on 01/01/23.
//

import Foundation
import RealmSwift
import SwiftUI


public enum TransactionType: Int, PersistableEnum {
    case paynet = 0
    case store = 1
    case p2p = 2
    case exchange = 3
}

public enum TransactionStatus: String, PersistableEnum {
    case success
    case failure
    case waiting
    
    public var text: String {
        switch self {
        case .success:
            return "success".localize
        case .failure:
            return "failed".localize
        case .waiting:
            return "waiting".localize
        }
    }
    
    public var color: Color {
        switch self {
        case .success:
            return .init(uiColor: .systemBlue)
        case .failure:
            return .init(uiColor: .systemRed)
        case .waiting:
            return .init(uiColor: .systemYellow)
        }
    }
}

public protocol TransactionItemProtocol: ModelProtocol {
    var id: String {get set}
    var agentName: String {get set}
    var status: TransactionStatus {get set}
    var amount: Float {get set}
    var currency: String {get set}
    var dateTime: Date {get set}
    var cardId: Int {get set}
    var type: TransactionType {get set}

}

public protocol TransactionSectionProtocol: ModelProtocol {
    var date: Date {get set}
}

public struct TransactionSection: TransactionSectionProtocol {
    public var id: String
    public var date: Date
    
    public init(id: String, date: Date) {
        self.id = id
        self.date = date
    }
}

public struct TransactionItem: TransactionItemProtocol {
    public var id: String
    
    public var agentName: String
    
    public var status: TransactionStatus
    
    public var amount: Float
    
    public var currency: String
    
    public var dateTime: Date
    
    public var cardId: Int
    
    public var type: TransactionType
    
    public private(set) var exchangeCardId: String?
    public private(set) var exchangeType: String?
    public private(set) var exchangeAmount: String?
    public private(set) var p2PCardNumber: String?
    public private(set) var p2PCardHolder: String?
    public private(set) var p2PCardId: String?
    public private(set) var commissionAmount: String?
    
    init(id: String, agentName: String, status: TransactionStatus, amount: Float, currency: String, dateTime: Date, cardId: Int, type: TransactionType) {
        self.id = id
        self.agentName = agentName
        self.status = status
        self.amount = amount
        self.currency = currency
        self.dateTime = dateTime
        self.cardId = cardId
        self.type = type
    }
    
    static func fromNetResTransactionItem(_ item: NetResTransactionItem) -> TransactionItem {
        // date form at for "2023-04-23T17:12:05.728508"
        let dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        return TransactionItem(id: "\(item.transactionId)", agentName: item.note ?? "", status: TransactionStatus(rawValue: "") ?? .success, amount: Float(item.amount), currency: "sum", dateTime: item.transactionTime, cardId: item.cardId, type: .init(rawValue: item.transactionType) ?? .paynet)
    }
    
}
