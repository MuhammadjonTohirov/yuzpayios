//
//  NetResInvoiceItem.swift
//  YuzPay
//
//  Created by applebro on 24/03/23.
//

import Foundation

public struct NetResInvoiceItem: Codable {
    public let invoiceID: Int
    public let operatorName, branchName, organizationName, clientName: String?
    public let totalAmount: Float?
    public let invoiceNote: String?
    public let createdDate: Date?
    public let isPaid, isExpired: Bool?

    enum CodingKeys: String, CodingKey {
        case invoiceID = "invoiceId"
        case operatorName, branchName, organizationName, clientName, totalAmount, invoiceNote, createdDate, isPaid, isExpired
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.invoiceID = try container.decode(Int.self, forKey: .invoiceID)
        self.operatorName = try? container.decodeIfPresent(String.self, forKey: .operatorName)
        self.branchName = try? container.decodeIfPresent(String.self, forKey: .branchName)
        self.organizationName = try? container.decodeIfPresent(String.self, forKey: .organizationName)
        self.clientName = try? container.decodeIfPresent(String.self, forKey: .clientName)
        self.totalAmount = try? container.decodeIfPresent(Float.self, forKey: .totalAmount)
        self.invoiceNote = try? container.decodeIfPresent(String.self, forKey: .invoiceNote)
        let createdDateString = try? container.decodeIfPresent(String.self, forKey: .createdDate)
        
        if let _createdDateString = createdDateString {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
            formatter.timeZone = .init(abbreviation: "GMT")
            self.createdDate = formatter.date(from: _createdDateString)
        } else {
            self.createdDate = nil
        }
        
        
        self.isPaid = try? container.decodeIfPresent(Bool.self, forKey: .isPaid)
        self.isExpired = try? container.decodeIfPresent(Bool.self, forKey: .isExpired)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(invoiceID, forKey: .invoiceID)
        try container.encodeIfPresent(operatorName, forKey: .operatorName)
        try container.encodeIfPresent(branchName, forKey: .branchName)
        try container.encodeIfPresent(organizationName, forKey: .organizationName)
        try container.encodeIfPresent(clientName, forKey: .clientName)
        try container.encodeIfPresent(totalAmount, forKey: .totalAmount)
        try container.encodeIfPresent(invoiceNote, forKey: .invoiceNote)
        try container.encodeIfPresent(createdDate, forKey: .createdDate)
        try container.encodeIfPresent(isPaid, forKey: .isPaid)
        try container.encodeIfPresent(isExpired, forKey: .isExpired)
    }
}

