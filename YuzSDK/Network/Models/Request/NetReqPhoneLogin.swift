//
//  NetReqConfirmOTP.swift
//  YuzPay
//
//  Created by applebro on 16/02/23.
//

import Foundation

struct NetReqPhoneLogin: Codable {
    struct Confirm: Codable {
        var token: String
        var code: String
    }
    
    var phone: String
    var confirm: Confirm
}
