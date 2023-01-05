//
//  TransactionItem.swift
//  YuzPay
//
//  Created by applebro on 01/01/23.
//

import Foundation
import RealmSwift
import SwiftUI

enum TransactionStatus: String, PersistableEnum {
    case success
    case failure
    case waiting
    
    var text: String {
        switch self {
        case .success:
            return "paid".localize
        case .failure:
            return "faled".localize
        case .waiting:
            return "waiting".localize
        }
    }
    
    var color: Color {
        switch self {
        case .success:
            return .systemBlue
        case .failure:
            return .systemRed
        case .waiting:
            return .systemYellow
        }
    }
}

protocol TransactionItemProtocol: ModelProtocol {
    var id: String {get set}
    var agentName: String {get set}
    var status: TransactionStatus {get set}
    var amount: Float {get set}
    var currency: String {get set}
    var dateTime: Date {get set}
}

protocol TransactionSectionProtocol: ModelProtocol {
    var date: Date {get set}
}

struct TransactionSection: TransactionSectionProtocol {
    var id: String
    var date: Date
}

struct TransactionItem: TransactionItemProtocol {
    var id: String
    
    var agentName: String
    
    var status: TransactionStatus
    
    var amount: Float
    
    var currency: String
    
    var dateTime: Date
}
