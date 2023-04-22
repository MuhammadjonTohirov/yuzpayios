//
//  CreditCardModel.swift
//  YuzPay
//
//  Created by applebro on 20/12/22.
//

import Foundation
import RealmSwift
import SwiftUI

enum CreditCardType: String, PersistableEnum, Identifiable {
    var id: String {
        rawValue
    }
    
    case uzcard
    case humo
    case visa
    case master
    case unionpay
    case wallet
    
    var localIcon: String {
        switch self {
        case .uzcard:
            return "icon_uzcard"
        case .humo:
            return "icon_humo"
        case .visa:
            return "icon_visa"
        case .master:
            return "icon_master"
        case .unionpay:
            return "icon_unionpay"
        case .wallet:
            return "icon_master"
        }
    }
    
    @ViewBuilder
    var whiteIcon: some View {
        switch self {
        case .uzcard:
            icon
                .renderingMode(.template)
                .foregroundColor(.white)
        default:
            icon
        }
    }
    
    @ViewBuilder
    var icon: Image {
        Image(localIcon)
    }
    
    var name: String {
        rawValue.localize.capitalized
    }
    
    static func create(cardTypeId: Int) -> CreditCardType {
        switch cardTypeId {
        case 0:
            return .uzcard
        case 1:
            return .humo
        case 2:
            return .visa
        case 3:
            return .master
        case 4:
            return .unionpay
        default:
            return .wallet
        }
    }
}

enum CreditCardStatus: Int, PersistableEnum {
    case active = 1
    case notConfirmed = 0
    case blocked = 2
    case deleted = 3
}

class DCard: Object, ObjectKeyIdentifiable, DItemProtocol, CardProtocol {
    @Persisted(primaryKey: true) var id: String
    @Persisted var cardNumber: String
    @Persisted var expirationDate: Date
    @Persisted var name: String
    @Persisted var holderName: String
    @Persisted var isMain: Bool
    @Persisted var bankName: String?
    @Persisted var icon: String?
    @Persisted var cardType: CreditCardType
    @Persisted var status: CreditCardStatus
    @Persisted var backgroundImage: String?
    @Persisted var colorCode: String?
    @Persisted var moneyAmount: Float
    
    init(id: String, cardNumber: String, expirationDate: Date,
         name: String, holderName: String, isMain: Bool, bankName: String? = nil,
         icon: String? = nil, cardType: CreditCardType, status: CreditCardStatus,
         backgroundImage: String? = nil, colorCode: String? = nil, moneyAmount: Float) {
        self.cardNumber = cardNumber
        self.expirationDate = expirationDate
        self.name = name
        self.holderName = holderName
        self.isMain = isMain
        self.bankName = bankName
        self.icon = icon
        self.cardType = cardType
        self.status = status
        self.backgroundImage = backgroundImage
        self.colorCode = colorCode
        self.moneyAmount = moneyAmount
        
        super.init()
        
        self.id = id
    }
    
    override init() {
        super.init()
    }
}

extension DCard {
    static func build(withModel model: CardModel) -> any DItemProtocol {
        return DCard(id: model.id, cardNumber: model.cardNumber, expirationDate: model.expirationDate,
                     name: model.name, holderName: model.holderName, isMain: model.isMain, cardType: model.cardType, status: model.status,
                     moneyAmount: model.moneyAmount)
    }
    
    func update(by model: CardModel) {
        self.cardNumber = model.cardNumber
        self.expirationDate = model.expirationDate
        self.name = model.name
        self.holderName = model.holderName
        self.isMain = model.isMain
        self.bankName = model.bankName
        self.icon = model.icon
        self.cardType = model.cardType
        self.status = model.status
        self.backgroundImage = model.backgroundImage
        self.colorCode = model.colorCode
        self.moneyAmount = model.moneyAmount
    }
    
    func set(isMain value: Bool) {
        if self.isMain != value {
            self.isMain = value
        }
    }
}
