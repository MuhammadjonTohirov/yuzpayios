//
//  DExchangeRate.swift
//  YuzSDK
//
//  Created by applebro on 16/05/23.
//

import Foundation
import RealmSwift

public class DExchangeRate: Object, Identifiable {
    public var id: Int {
        currencyID.rawValue
    }
    
    @Persisted(primaryKey: true) public var currencyID: CurrencyType
    @Persisted public var name: String
    @Persisted public var code: String
    @Persisted public var number: String?
    @Persisted public var buyingRate: Float
    @Persisted public var sellingRate: Float
    @Persisted public var lastRefreshed: Date?
    
    public init(currencyType: CurrencyType, name: String, code: String, number: String? = nil, buyingRate: Float, sellingRate: Float, lastRefreshed: Date? = nil) {
        self.name = name
        self.code = code
        self.number = number
        self.buyingRate = buyingRate
        self.sellingRate = sellingRate
        self.lastRefreshed = lastRefreshed
        super.init()
        self.currencyID = currencyType
    }
    
    override public init() {
        super.init()
    }
    
    static func create(with res: NetResExchangeRate) -> DExchangeRate {
        .init(currencyType: .init(rawValue: res.currencyID) ?? .usd, name: res.name, code: res.code, buyingRate: res.buyingRate, sellingRate: res.sellingRate, lastRefreshed: res.lastRefreshed)
    }
    
    var asModel: ExchangeRate {
        .init(currencyID: self.currencyID, name: self.name, code: self.code, buyingRate: self.buyingRate, sellingRate: self.sellingRate, lastRefreshed: self.lastRefreshed)
    }
}

public protocol ExchangeRateProtocol: ModelProtocol {
    
}

public class ExchangeRate: ExchangeRateProtocol, Identifiable {
    public var id: Int {
        currencyID.rawValue
    }
    
    public var currencyID: CurrencyType
    public var name: String
    public var code: String
    public var number: String?
    public var buyingRate: Float
    public var sellingRate: Float
    public var lastRefreshed: Date?
    
    public init(currencyID: CurrencyType, name: String, code: String, number: String? = nil, buyingRate: Float, sellingRate: Float, lastRefreshed: Date? = nil) {
        self.name = name
        self.code = code
        self.number = number
        self.buyingRate = buyingRate
        self.sellingRate = sellingRate
        self.lastRefreshed = lastRefreshed
        self.currencyID = currencyID
    }
    
    static func create(with res: NetResExchangeRate) -> ExchangeRate {
        .init(currencyID: .init(rawValue: res.currencyID) ?? .usd,
              name: res.name, code: res.code, buyingRate: res.buyingRate, sellingRate: res.sellingRate, lastRefreshed: res.lastRefreshed)
    }
}
