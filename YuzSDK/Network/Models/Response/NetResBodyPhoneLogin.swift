//
//  NetBodyOTPConfirm.swift
//  YuzPay
//
//  Created by applebro on 16/02/23.
//

import Foundation

struct NetResBodyPhoneLogin: NetResBody {
    let accessToken: String
    let expiresIn, refreshExpiresIn: Double
    let refreshToken, tokenType: String
    let notBeforePolicy: Int
    let sessionState, scope: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiresIn = "expires_in"
        case refreshExpiresIn = "refresh_expires_in"
        case refreshToken = "refresh_token"
        case tokenType = "token_type"
        case notBeforePolicy = "not-before-policy"
        case sessionState = "session_state"
        case scope
    }
}
