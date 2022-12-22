//
//  PaymentCategoryModel.swift
//  YuzPay
//
//  Created by applebro on 21/12/22.
//

import Foundation

protocol PaymentCategoryProtocol: ModelProtocol {
    var id: String {get set}
    var title: String {get set}
    var icon: String {get set}
}

struct PaymentCategoryModel: PaymentCategoryProtocol {
    var id: String
    var title: String
    var icon: String
}
