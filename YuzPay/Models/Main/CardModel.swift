//
//  CardModel.swift
//  YuzPay
//
//  Created by applebro on 21/12/22.
//

import Foundation
import YuzSDK

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
    
    var holderName: String
    
    var isMain: Bool
    
    var bankName: String?
    
    var icon: String?
    
    var cardType: CreditCardType
    
    var status: CreditCardStatus
    
    var backgroundImage: String?
    
    var colorCode: String?
    
    var moneyAmount: Float
    
    static func create(res card: NetResCardItem) -> CardModel {
        let exDate = Date.from(string: card.expirationDate ?? "", format: "MM/yy") ?? Date()
        
        let cardModel = CardModel(id: "\(card.id)",
                                  cardNumber: card.cardNumber ?? "",
                                  expirationDate: exDate,
                                  name: card.cardName ?? "", holderName: card.cardHolder ?? "", isMain: card.isDefault,
                                  bankName: nil,
                                  icon: nil, cardType: .create(cardTypeId: card.type ?? 0),
                                  status: .init(rawValue: card.statusCode ?? 0) ?? .active,
                                  backgroundImage: nil, colorCode: nil, moneyAmount: Float(card.balance ?? 0))
        return cardModel
    }
}


