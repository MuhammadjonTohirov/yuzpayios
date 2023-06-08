//
//  MerchantFormProtocol.swift
//  YuzPay
//
//  Created by applebro on 02/05/23.
//

import Foundation
import YuzSDK

protocol MerchantFormProtocol {
    var merchantId: Int {get}
    var categoryId: Int {get}
    var fields: [any MFormFieldProtocol] {get}
}

protocol MFormFieldProtocol  {
    var text: String {get set}
    var field: any MFieldProtocol {get}
}
