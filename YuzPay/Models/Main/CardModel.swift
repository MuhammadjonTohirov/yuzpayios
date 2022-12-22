//
//  CardModel.swift
//  YuzPay
//
//  Created by applebro on 21/12/22.
//

import Foundation

protocol CardProtocol: ModelProtocol {
    var id: String {get set}
    var cardNumber: String {get set}
    var expirationDate: Date {get set}
    var name: String {get set}
    var isMain: Bool {get set}
    var bankName: String? {get set}
    var icon: String? {get set}
    var cardType: CreditCardType {get set}
    var status: CreditCardStatus {get set}
    var backgroundImage: String? {get set}
    var colorCode: String? {get set}
    var moneyAmount: Float {get set}
}

struct CardModel: ModelProtocol, CardProtocol {
    var id: String
    
    var cardNumber: String
    
    var expirationDate: Date
    
    var name: String
    
    var isMain: Bool
    
    var bankName: String?
    
    var icon: String?
    
    var cardType: CreditCardType
    
    var status: CreditCardStatus
    
    var backgroundImage: String?
    
    var colorCode: String?
    
    var moneyAmount: Float
}
