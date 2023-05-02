//
//  TransactionItem.swift
//  YuzPay
//
//  Created by applebro on 01/01/23.
//

import Foundation
import RealmSwift
import SwiftUI


public enum TransactionType: Int {
    case paynet
    case store
    case p2p
    case exchange
}

public enum TransactionStatus: String, PersistableEnum {
    case success
    case failure
    case waiting
    
    public var text: String {
        switch self {
        case .success:
            return "paid".localize
        case .failure:
            return "faled".localize
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
    
    public init(id: String, agentName: String, status: TransactionStatus, amount: Float, currency: String, dateTime: Date) {
        self.id = id
        self.agentName = agentName
        self.status = status
        self.amount = amount
        self.currency = currency
        self.dateTime = dateTime
    }
}
