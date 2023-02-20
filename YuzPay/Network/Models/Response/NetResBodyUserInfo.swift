//
//  NetResBodyUserInfo.swift
//  YuzPay
//
//  Created by applebro on 18/02/23.
//

import SwiftUI

struct NetResBodyUserInfo: NetResBody {
    let sub, preferredUsername: String?
    let familyName, givenName: String?
    let name, email: String?
    let emailVerified: Bool?
    let locale: String?

    enum CodingKeys: String, CodingKey {
        case sub
        case preferredUsername = "preferred_username"
        case familyName = "family_name"
        case givenName = "given_name"
        case name, email
        case emailVerified = "email_verified"
        case locale
    }
}
