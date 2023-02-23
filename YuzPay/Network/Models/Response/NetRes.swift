//
//  NetRes.swift
//  YuzPay
//
//  Created by applebro on 15/02/23.
//

import Foundation

protocol NetResBody: Codable {
    
}

struct NetRes<T: NetResBody>: Codable {
    let success: Bool
    let data: T?
    let error: String?
    let code: Int?
}
