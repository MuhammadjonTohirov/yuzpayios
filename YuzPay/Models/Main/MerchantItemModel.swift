//
//  PaymentItemModel.swift
//  YuzPay
//
//  Created by applebro on 21/12/22.
//

import Foundation

protocol PaymentServiceProtocol: ModelProtocol {
    var id: String {get set}
    var title: String {get set}
    var icon: String {get set}
    var type: String {get set}
}

struct MerchantItemModel: ModelProtocol, PaymentServiceProtocol {
    var id: String
    var title: String
    var icon: String
    var type: String
}
