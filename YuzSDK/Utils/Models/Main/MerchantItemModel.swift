//
//  PaymentItemModel.swift
//  YuzPay
//
//  Created by applebro on 21/12/22.
//

import Foundation

public protocol PaymentServiceProtocol: ModelProtocol {
    var id: String {get set}
    var title: String {get set}
    var icon: String {get set}
    var categoryId: Int {get set}
}

public struct MerchantItemModel: ModelProtocol, PaymentServiceProtocol {
    public var id: String
    public var title: String
    public var icon: String
    public var categoryId: Int
    
    public init(id: String, title: String, icon: String, categoryId: Int) {
        self.id = id
        self.title = title
        self.icon = icon
        self.categoryId = categoryId
    }
}
