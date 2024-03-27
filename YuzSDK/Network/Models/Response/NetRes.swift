//
//  NetRes.swift
//  YuzPay
//
//  Created by applebro on 15/02/23.
//

import Foundation

public protocol NetResBody: Codable {
    
}

public struct NetRes<T: NetResBody>: Codable {
    public let success: Bool
    public let data: T?
    public let error: String?
    public let code: Int?
}
