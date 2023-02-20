//
//  NetBodyCheckPhone.swift
//  YuzPay
//
//  Created by applebro on 15/02/23.
//

import Foundation

struct NetBodyCheckPhone: NetResBody {
    let exists: Bool
    let token: String
    let code: String // stands for otp
}
