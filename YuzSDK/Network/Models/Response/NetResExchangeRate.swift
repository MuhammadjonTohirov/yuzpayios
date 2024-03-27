//
//  NetResExchangeRate.swift
//  YuzSDK
//
//  Created by applebro on 16/05/23.
//

import Foundation

struct NetResExchangeRate: Decodable, NetResBody {
    let currencyID: Int
    let name: String
    let code: String?
    let number: String?
    let buyingRate, sellingRate: Float
    let lastRefreshed: Date?

    enum CodingKeys: String, CodingKey {
        case currencyID = "currencyId"
        case name, code, number, buyingRate, sellingRate, lastRefreshed
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.currencyID = try container.decode(Int.self, forKey: .currencyID)
        self.name = try container.decode(String.self, forKey: .name)
        self.code = try container.decodeIfPresent(String.self, forKey: .code)
        self.number = try container.decode(String.self, forKey: .number)
        self.buyingRate = try container.decode(Float.self, forKey: .buyingRate)
        self.sellingRate = try container.decode(Float.self, forKey: .sellingRate)
        let createdDateString = try? container.decodeIfPresent(String.self, forKey: .lastRefreshed)
        
        if let date = createdDateString {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
            formatter.timeZone = .init(abbreviation: "GMT")
            self.lastRefreshed = formatter.date(from: date)
        } else {
            self.lastRefreshed = nil
        }
    }
}
