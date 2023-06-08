//
//  CardModel.swift
//  YuzPay
//
//  Created by applebro on 21/12/22.
//

import Foundation
import RealmSwift

public enum CurrencyType: Int, PersistableEnum {
    case uzs = 1
    case usd
    case eur
    case rub
    case gbp
}

protocol CardProtocol: ModelProtocol {
    var id: String {get set}
    var ownerId: String {get set}
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
    var currencyType: CurrencyType {get set}
}

public struct CardModel: ModelProtocol, CardProtocol {
    
    public var id: String

    public var ownerId: String

    public var cardNumber: String
    
    public var expirationDate: Date
    
    public var name: String
    
    public var holderName: String
    
    public var isMain: Bool
    
    public var bankName: String?
    
    public var icon: String?
    
    public var cardType: CreditCardType
    
    public var status: CreditCardStatus
    
    public var currencyType: CurrencyType
    
    public var backgroundImage: String?
    
    public var colorCode: String?
    
    public var moneyAmount: Float
    
    static func create(res card: NetResCardItem) -> CardModel {
        let exDate = Date.from(string: card.expirationDate ?? "", format: "MM/yy") ?? Date()
        
        let cardModel = CardModel(id: "\(card.id)",
                                  ownerId: card.clientId ?? "",
                                  cardNumber: card.cardNumber ?? "",
                                  expirationDate: exDate,
                                  name: card.cardName ?? "",
                                  holderName: card.cardHolder ?? "", isMain: card.isDefault,
                                  bankName: nil,
                                  icon: nil, cardType: .create(cardTypeId: card.typeID ?? 0),
                                  status: .init(rawValue: card.statusCode ?? 0) ?? .active, currencyType: .init(rawValue: card.currencyId ?? 0) ?? .uzs,
                                  backgroundImage: nil, colorCode: nil, moneyAmount: Float(card.balance ?? 0))
        return cardModel
    }
}


