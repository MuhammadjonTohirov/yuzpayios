//
//  CreditCardModel.swift
//  YuzPay
//
//  Created by applebro on 20/12/22.
//

import Foundation
import RealmSwift
import SwiftUI

public enum CreditCardType: String, PersistableEnum, Identifiable {
    public var id: String {
        rawValue
    }
    
    case uzcard
    case humo
    case visa
    case master
    case unionpay
    case wallet
    
    public var localIcon: String {
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
    public var whiteIcon: some View {
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
    public var icon: Image {
        Image(localIcon)
    }
    
    public var name: String {
        rawValue.localize.capitalized
    }
    
    public static func create(cardTypeId: Int) -> CreditCardType {
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
    
    public var code: Int {
        switch self {
        case .uzcard:
            return 0
        case .humo:
            return 1
        case .visa:
            return 2
        case .master:
            return 3
        case .unionpay:
            return 4
        case .wallet:
            return 5
        }
    }
}

public enum CreditCardStatus: Int, PersistableEnum {
    case active = 1
    case notConfirmed = 0
    case blocked = 2
    case deleted = 3
}

public class DCard: Object, ObjectKeyIdentifiable, DItemProtocol, CardProtocol {
    @Persisted(primaryKey: true) public var id: String
    @Persisted public var cardNumber: String
    @Persisted public var expirationDate: Date
    @Persisted public var name: String
    @Persisted public var holderName: String
    @Persisted public var isMain: Bool
    @Persisted public var bankName: String?
    @Persisted public var icon: String?
    @Persisted public var cardType: CreditCardType
    @Persisted public var status: CreditCardStatus
    @Persisted public var backgroundImage: String?
    @Persisted public var colorCode: String?
    @Persisted public var moneyAmount: Float
    
    @Persisted public var currencyType: CurrencyType
    
    public init(id: String, cardNumber: String, expirationDate: Date,
         name: String, holderName: String, isMain: Bool, bankName: String? = nil,
         icon: String? = nil, cardType: CreditCardType, status: CreditCardStatus,
                backgroundImage: String? = nil, colorCode: String? = nil, moneyAmount: Float, currency: CurrencyType = .uzs) {
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
        self.currencyType = currency
        super.init()
        
        self.id = id
    }
    
    public override init() {
        super.init()
    }
}

public extension CreditCardType {
    static func detectCardType(cardNumber: String) -> CreditCardType? {
        if cardNumber.range(of: "^(8600|9874)[0-9]{0,11}$", options: .regularExpression) != nil {
            return .uzcard
        } else if cardNumber.range(of: "^9860[0-9]{0,11}$", options: .regularExpression) != nil {
            return .humo
        } else if cardNumber.range(of: "^4[0-9]{0,15}$", options: .regularExpression) != nil {
            return .visa
        } else if cardNumber.range(of: "^(5[1-5]|2[2-7])[0-9]{0,14}$", options: .regularExpression) != nil {
            return .master
        } else if cardNumber.range(of: "^62[0-9]{0,17}$", options: .regularExpression) != nil {
            return .unionpay
        } else {
            return nil
        }
    }
}

public extension DCard {
    static func build(withModel model: CardModel) -> any DItemProtocol {
        return DCard(id: model.id, cardNumber: model.cardNumber, expirationDate: model.expirationDate,
                     name: model.name, holderName: model.holderName, isMain: model.isMain, cardType: model.cardType, status: model.status,
                     moneyAmount: model.moneyAmount, currency: model.currencyType)
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
        self.currencyType = model.currencyType
    }
    
    func set(isMain value: Bool) {
        if self.isMain != value {
            self.isMain = value
        }
    }
}

public class DSavedCard: DCard {
    
}
